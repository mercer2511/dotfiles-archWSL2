require "nvchad.mappings"

local map = vim.keymap.set

-- NvChad custom mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- General mappings
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Tmux Navigator (hjkl clásico)
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right" })

-- ✅ Java formatting y indentación
map("n", "<leader>jf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Java file" })

map("n", "<leader>ji", "gg=G", { desc = "Auto-indent entire Java file" })
map("v", "<leader>ji", "=", { desc = "Auto-indent selected lines" })

-- ✅ FUNCIONES INTELIGENTES PARA DETECTAR TIPO DE PROYECTO
local function find_project_root()
  local current_dir = vim.fn.expand('%:p:h')
  
  -- Buscar hacia arriba por archivos de proyecto
  local root = vim.fn.findfile('pom.xml', current_dir .. ';')
  if root ~= '' then
    return vim.fn.fnamemodify(root, ':h'), 'maven'
  end
  
  root = vim.fn.findfile('build.gradle', current_dir .. ';')
  if root ~= '' then
    return vim.fn.fnamemodify(root, ':h'), 'gradle'
  end
  
  root = vim.fn.finddir('.git', current_dir .. ';')
  if root ~= '' then
    return vim.fn.fnamemodify(root, ':h'), 'git'
  end
  
  return current_dir, 'simple'
end

local function get_java_class_name()
  local file_path = vim.fn.expand('%:p')
  local content = vim.fn.readfile(file_path)
  
  for _, line in ipairs(content) do
    local package_match = line:match('package%s+([%w%.]+)%s*;')
    if package_match then
      local class_name = vim.fn.expand('%:t:r')
      return package_match .. '.' .. class_name
    end
  end
  
  return vim.fn.expand('%:t:r') -- Sin paquete
end

-- ✅ KEYMAPS JAVA OPTIMIZADOS
-- Ejecución rápida no-interactiva (Maven exec - para desarrollo sin Scanner)
map("n", "<leader>jr", function()
  local project_root, project_type = find_project_root()
  
  if project_type == 'maven' then
    vim.cmd(string.format("!cd '%s' && mvn compile exec:java -Dexec.mainClass='%s'", 
           project_root, get_java_class_name()))
  elseif project_type == 'gradle' then
    vim.cmd(string.format("!cd '%s' && ./gradlew run", project_root))
  else
    -- Proyecto simple
    local file = vim.fn.expand('%:t')
    local file_no_ext = vim.fn.expand('%:t:r')
    local dir = vim.fn.expand('%:p:h')
    vim.cmd(string.format("!cd '%s' && javac '%s' && java '%s'", dir, file, file_no_ext))
  end
end, { desc = "Java: Quick run (non-interactive)" })

-- Compilación inteligente
map("n", "<leader>jc", function()
  local project_root, project_type = find_project_root()
  
  if project_type == 'maven' then
    vim.cmd(string.format("!cd '%s' && mvn compile", project_root))
  elseif project_type == 'gradle' then
    vim.cmd(string.format("!cd '%s' && ./gradlew compileJava", project_root))
  else
    local file = vim.fn.expand('%:t')
    local dir = vim.fn.expand('%:p:h')
    vim.cmd(string.format("!cd '%s' && javac '%s'", dir, file))
  end
end, { desc = "Java: Smart compile" })

-- ✅ KEYMAPS MAVEN ESPECÍFICOS
map("n", "<leader>mr", function()
  local project_root = find_project_root()
  vim.cmd(string.format("!cd '%s' && mvn exec:java", project_root))
end, { desc = "Maven: Run main class" })

map("n", "<leader>mc", function()
  local project_root = find_project_root()
  vim.cmd(string.format("!cd '%s' && mvn compile", project_root))
end, { desc = "Maven: Compile" })

map("n", "<leader>mt", function()
  local project_root = find_project_root()
  vim.cmd(string.format("!cd '%s' && mvn test", project_root))
end, { desc = "Maven: Test" })

map("n", "<leader>mp", function()
  local project_root = find_project_root()
  vim.cmd(string.format("!cd '%s' && mvn package", project_root))
end, { desc = "Maven: Package" })

-- ✅ EJECUCIÓN CON CLASSPATH CORRECTO (útil para debug)
map("n", "<leader>jx", function()
  local project_root = find_project_root()
  local class_name = get_java_class_name()
  vim.cmd(string.format("!cd '%s' && java -cp target/classes %s", project_root, class_name))
end, { desc = "Java: Execute with correct classpath" })

-- LSP Diagnostics mejorados
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP shortcuts (complementar los default de NvChad)
map("n", "gh", vim.lsp.buf.hover, { desc = "LSP hover documentation" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

-- Telescope para Java
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Find diagnostics" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Find symbols" })

-- ✅ TERMINALES OPTIMIZADOS
map("n", "<leader>tt", "<cmd>split | resize 10 | terminal<CR>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Vertical terminal" })

-- ✅ EJECUCIÓN INTERACTIVA (PARA SCANNER/INPUT) - TU FAVORITO
map("n", "<leader>mi", function()
  local project_root = find_project_root()
  local class_name = get_java_class_name()
  
  -- Crear terminal vertical y ejecutar comando
  vim.cmd("vsplit")
  vim.cmd("terminal")
  
  -- Enviar comando al terminal
  local cmd = string.format("cd '%s' && mvn compile && java -cp target/classes %s", 
                           project_root, class_name)
  
  -- Esperar un momento y enviar el comando
  vim.defer_fn(function()
    local chan = vim.b.terminal_job_id
    if chan then
      vim.fn.chansend(chan, cmd .. "\n")
    end
  end, 100)
end, { desc = "Maven: Interactive run (for Scanner input)" })

-- ✅ TMUX CON PAUSA - PERFECTO COMO ESTÁ
map("n", "<leader>mx", function()
  local project_root = find_project_root()
  local class_name = get_java_class_name()
  
  if vim.env.TMUX then
    local temp_script = "/tmp/java_run_script.sh"
    local script_content = string.format([[#!/bin/bash
cd '%s'
echo "🚀 Compilando proyecto Maven..."
mvn compile
echo "☕ Ejecutando: %s"
echo "==========================================="
java -cp target/classes %s
echo "==========================================="
echo "✅ Programa terminado."
echo "Presiona ENTER para cerrar..."
read
]], project_root, class_name, class_name)
    
    local file = io.open(temp_script, "w")
    if file then
      file:write(script_content)
      file:close()
      vim.fn.system("chmod +x " .. temp_script)
      vim.fn.system("tmux new-window -n 'java-run' 'bash " .. temp_script .. "'")
      print("🚀 Ejecutando en nueva ventana tmux...")
    else
      print("❌ Error creando script temporal")
    end
  else
    print("❌ No estás en una sesión tmux")
  end
end, { desc = "Maven: Run in tmux with pause" })

-- ✅ TMUX CON ZSH PERSISTENTE (MEJORADO)
map("n", "<leader>mX", function()
  local project_root = find_project_root()
  local class_name = get_java_class_name()
  
  if vim.env.TMUX then
    local temp_script = "/tmp/java_zsh_script.sh"
    local script_content = string.format([[#!/bin/bash
cd '%s'
echo "🚀 Compilando y ejecutando..."
mvn compile && java -cp target/classes %s
echo "✅ Programa terminado. Shell ZSH permanece abierto."
echo "Escribe 'exit' para cerrar esta ventana."
exec zsh
]], project_root, class_name)
    
    local file = io.open(temp_script, "w")
    if file then
      file:write(script_content)
      file:close()
      vim.fn.system("chmod +x " .. temp_script)
      vim.fn.system("tmux new-window -n 'java-zsh' 'bash " .. temp_script .. "'")
      print("🚀 Ejecutando en tmux con zsh persistente...")
    end
  else
    print("❌ No estás en tmux")
  end
end, { desc = "Maven: Run in tmux with persistent zsh" })
