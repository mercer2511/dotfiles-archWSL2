# 🏠 Dotfiles

Configuraciones personalizadas para **Arch Linux WSL2** con Zsh, Oh My Posh, NeoVim (NvChad), tmux y Windows Terminal.

## 🖥️ Entorno de Desarrollo

Este setup está diseñado específicamente para:
- **Sistema**: Arch Linux en WSL2 (Windows 11)
- **Terminal**: Windows Terminal con temas Catppuccin
- **Editor**: NeoVim con NvChad y personalizaciones para Java
- **Multiplexor**: tmux con tema Catppuccin
- **Shell**: Zsh con Oh My Posh
- **Compatibilidad**: Modo claro/oscuro automático

## 📋 Requisitos Previos

### Sistema Base (Arch Linux WSL2)
```bash
# Actualizar sistema
sudo pacman -Syu

# Instalar herramientas básicas
sudo pacman -S base-devel git curl wget unzip
```

### Instalar Yay (AUR Helper)
```bash
# Clonar yay desde AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

### Gestor de Dotfiles
```bash
# Instalar GNU Stow
sudo pacman -S stow
```

## 🛠️ Instalación Completa

### 1. Clonar Dotfiles
```bash
cd ~
git clone https://github.com/mercer2511/dotfiles-archWSL2.git dotfiles
cd dotfiles
```

### 2. Instalar Zsh y Dependencias
```bash
# Instalar Zsh
sudo pacman -S zsh

# Cambiar shell por defecto
chsh -s $(which zsh)

# Instalar herramientas adicionales
sudo pacman -S fzf zoxide keychain
```

### 3. Instalar Oh My Posh
```bash
# Opción 1: Usando yay (Recomendado)
yay -S oh-my-posh

# Opción 2: Instalación manual si yay falla
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
```

### 4. Instalar NeoVim y tmux
```bash
# Instalar NeoVim y tmux
sudo pacman -S neovim tmux

# Instalar LazyGit para integración Git
sudo pacman -S lazygit

# Instalar ripgrep y fd (dependencias para búsquedas)
sudo pacman -S ripgrep fd
```

### 5. Instalar NvChad (base para NeoVim)
```bash
# Hacer backup de configuración existente (si existe)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# Clonar NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
```

### 6. Configurar Windows Terminal (Windows 11)

#### Instalar Fuentes Nerd Font en Windows
```powershell
# Descargar JetBrains Mono Nerd Font desde Windows
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
# Extraer e instalar las fuentes .ttf haciendo doble clic en Windows
```

#### Configurar Temas Catppuccin
Agregar a tu `settings.json` de Windows Terminal:

```json
{
  "schemes": [
    {
      "name": "Catppuccin Mocha",
      "background": "#1E1E2E",
      "black": "#45475A",
      "blue": "#89B4FA",
      "brightBlack": "#585B70",
      "brightBlue": "#89B4FA",
      "brightCyan": "#94E2D5",
      "brightGreen": "#A6E3A1",
      "brightPurple": "#F5C2E7",
      "brightRed": "#F38BA8",
      "brightWhite": "#A6ADC8",
      "brightYellow": "#F9E2AF",
      "cursorColor": "#F5E0DC",
      "cyan": "#94E2D5",
      "foreground": "#CDD6F4",
      "green": "#A6E3A1",
      "purple": "#F5C2E7",
      "red": "#F38BA8",
      "selectionBackground": "#585B70",
      "white": "#BAC2DE",
      "yellow": "#F9E2AF"
    },
    {
      "name": "Catppuccin Latte",
      "background": "#EFF1F5",
      "black": "#5C5F77",
      "blue": "#1E66F5",
      "brightBlack": "#ACB0BE",
      "brightBlue": "#1E66F5",
      "brightCyan": "#179299",
      "brightGreen": "#40A02B",
      "brightPurple": "#EA76CB",
      "brightRed": "#D20F39",
      "brightWhite": "#BCC0CC",
      "brightYellow": "#DF8E1D",
      "cursorColor": "#DC8A78",
      "cyan": "#179299",
      "foreground": "#4C4F69",
      "green": "#40A02B",
      "purple": "#EA76CB",
      "red": "#D20F39",
      "selectionBackground": "#ACB0BE",
      "white": "#ACB0BE",
      "yellow": "#DF8E1D"
    }
  ],
  "profiles": {
    "defaults": {
      "colorScheme": {
        "dark": "Catppuccin Mocha",
        "light": "Catppuccin Latte"
      },
      "font": {
        "face": "JetBrains Mono",
        "size": 11
      }
    }
  }
}
```

### 7. Configurar SSH (Opcional)
```bash
# Generar clave SSH si no existe
ssh-keygen -t ed25519 -C "tu-email@example.com"

# Añadir clave al agente SSH
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## 🔗 Aplicar Configuraciones

### Usar GNU Stow
```bash
# Desde el directorio dotfiles
stow .

# Verificar symlinks creados
ls -la ~ | grep "\->"
ls -la ~/.config/ | grep "\->"
```

### Verificar Instalación
```bash
# Cerrar y reabrir terminal WSL2 o ejecutar
source ~/.zshrc

# Verificar Oh My Posh
oh-my-posh version

# Verificar que el tema se carga correctamente
echo $PROMPT_COMMAND

# Verificar NeoVim
nvim --version

# Verificar tmux
tmux -V
```

### Configuración Inicial de NeoVim
```bash
# Iniciar NeoVim por primera vez para instalar plugins
nvim

# Ejecutar dentro de NeoVim para verificar estado de plugins
:checkhealth
:Mason
```

## 📁 Estructura del Proyecto

```
dotfiles/
├── .stow-local-ignore        # Archivos ignorados por Stow
├── .zshrc                    # Configuración Zsh con Zinit
├── .config/
│   ├── nvim/                 # Configuración NeoVim/NvChad
│   │   ├── init.lua          # Archivo principal de configuración
│   │   ├── lazy-lock.json    # Versiones fijas de plugins
│   │   └── lua/              # Configuraciones modulares
│   │       ├── autocmds.lua  # Comandos automáticos
│   │       ├── chadrc.lua    # Configuración NvChad
│   │       ├── mappings.lua  # Keymaps personalizados
│   │       ├── options.lua   # Opciones de NeoVim
│   │       ├── configs/      # Configuraciones específicas
│   │       │   ├── conform.lua     # Formateo de código
│   │       │   ├── lazy.lua        # Gestor de plugins
│   │       │   └── lspconfig.lua   # Servidores LSP
│   │       └── plugins/      # Plugins adicionales
│   │           └── init.lua  # Configuración de plugins
│   ├── ohmyposh/
│   │   ├── base.json         # Configuración base
│   │   └── zen.toml          # Tema minimalista personalizado
│   └── tmux/                 # Configuración de tmux
│       ├── tmux.conf         # Archivo principal de configuración
│       └── plugins/          # Plugins de tmux
│           └── catppuccin-tmux/  # Tema Catppuccin para tmux
└── README.md                 # Este archivo
```

## ⚙️ Componentes Incluidos

### Zsh con Zinit
- **Plugin Manager**: Zinit para gestión rápida de plugins
- **Plugins optimizados**:
  - `zsh-syntax-highlighting` - Resaltado de sintaxis en tiempo real
  - `zsh-completions` - Completados adicionales
  - `zsh-autosuggestions` - Sugerencias basadas en historial
  - `fzf-tab` - Completados interactivos con fuzzy finder

### Oh My Posh - Tema Zen
- **Diseño minimalista** adaptado para productividad
- **Información contextual**:
  - Path completo del directorio actual
  - Estado Git con iconos informativos
  - Tiempo de ejecución (solo comandos >5s)
  - Prompt dinámico con colores de estado
- **Transient prompt** para historial limpio
- **Compatible con temas claro/oscuro** de Windows Terminal

### NeoVim (NvChad personalizado)
- **Base**: NvChad para configuración inicial y UI optimizada
- **LSP**: Servidores de lenguaje configurados para Java y otros lenguajes
- **Personalizaciones Java**:
  - Detección automática de proyectos Maven/Gradle
  - Keymaps específicos para compilación y ejecución
  - Integración con tmux para ejecución interactiva
- **Plugins destacados**:
  - LazyGit integrado (`<leader>gg`)
  - Formateo de código automático
  - Autocompletado inteligente

### tmux con Catppuccin
- **Tema**: Catppuccin para consistencia visual
- **Keybindings**: Optimizados para desarrolladores
- **Integración**: Con NeoVim para movimiento entre paneles
- **Sesiones persistentes**: Para desarrollo continuo

### Herramientas Integradas
- **FZF**: Búsqueda fuzzy en archivos, historial y comandos
- **Zoxide**: Navegación inteligente con `cd` mejorado
- **Keychain**: Gestión automática de claves SSH en WSL2
- **LazyGit**: TUI para Git integrado en NeoVim

## � Keymaps Principales

### NeoVim - General
- `<Space>` - Tecla líder
- `<C-h/j/k/l>` - Navegar entre splits/tmux
- `<C-s>` - Guardar archivo

### NeoVim - Java
- `<leader>jr` - Compilar y ejecutar (no interactivo)
- `<leader>mi` - Ejecutar en terminal interactivo (para Scanner)
- `<leader>mx` - Ejecutar en nueva ventana tmux
- `<leader>jf` - Formatear código Java
- `<leader>jc` - Compilar proyecto
- `<leader>mp` - Empaquetar proyecto Maven

### tmux
- `<C-a>` - Prefijo tmux
- `<C-a>c` - Nueva ventana
- `<C-a>|` - Split vertical
- `<C-a>-` - Split horizontal
- `<C-a>h/j/k/l` - Navegar entre paneles

## �🎨 Personalización

### Cambiar Configuración de Oh My Posh
```bash
# Editar tema personalizado
nano ~/.config/ohmyposh/zen.toml

# Recargar configuración
source ~/.zshrc
```

### Personalizar NeoVim
```bash
# Editar keymaps
nvim ~/.config/nvim/lua/mappings.lua

# Modificar plugins
nvim ~/.config/nvim/lua/plugins/init.lua

# Actualizar opciones
nvim ~/.config/nvim/lua/options.lua
```

### Modificar Configuración tmux
```bash
# Editar archivo principal
nvim ~/.config/tmux/tmux.conf

# Aplicar cambios sin reiniciar
tmux source-file ~/.config/tmux/tmux.conf
```

### Sincronización con Tema del Sistema
Los colores se adaptan automáticamente según el tema (claro/oscuro) configurado en Windows 11.

## 🐛 Solución de Problemas

### Instalación de Oh My Posh

#### Si yay no funciona:
```bash
# Verificar que yay esté instalado correctamente
yay --version

# Si no está instalado, reinstalar yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### NeoVim/NvChad

#### Plugins no se instalan:
```bash
# Dentro de NeoVim
:Lazy sync

# O reinstalar desde cero
rm -rf ~/.local/share/nvim
rm -rf ~/.config/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
# Aplicar dotfiles nuevamente con stow
```

#### LSP no funciona:
```bash
# Verificar instalación de servidores LSP
:Mason

# Instalar manualmente
:MasonInstall jdtls pyright
```

### tmux

#### Tema Catppuccin no se carga:
```bash
# Reiniciar tmux completamente
tmux kill-server
tmux

# O recargar configuración
tmux source-file ~/.config/tmux/tmux.conf
```

### WSL2 Específicos

#### Zinit no se carga correctamente
```bash
# Limpiar instalación de Zinit
rm -rf ~/.local/share/zinit

# Reiniciar terminal y Zinit se reinstalará automáticamente
```

#### Fuentes no se muestran en Windows Terminal
1. **Verificar instalación**: Las fuentes deben instalarse en Windows, no en WSL2
2. **Reiniciar completamente** Windows Terminal
3. **Verificar configuración** en `settings.json`

## 📝 Notas Importantes

### Primera Configuración
- **Primer inicio NeoVim**: Instalará plugins automáticamente (2-3 minutos)
- **Primer inicio Zsh**: Zinit descargará plugins automáticamente (1-2 minutos)
- **Rendimiento**: Optimizado para WSL2, carga rápida después de la configuración inicial
- **Compatibilidad**: Probado exclusivamente en Arch Linux WSL2 con Windows 11

### Desarrollo Java
- Configuración optimizada para proyectos Maven y Gradle
- LSP con autocompletado, análisis de código y navegación
- Keymaps específicos para compilación y ejecución

### Características WSL2
- Integración completa con sistema de archivos Windows
- Soporte para copiar/pegar entre WSL2 y Windows
- Gestión automática de agente SSH persistente entre sesiones

### Recomendaciones de Uso
- **Usar yay** para Oh My Posh (más fácil de actualizar)
- **Instalar fuentes en Windows** para mejor compatibilidad
- **Configurar temas en Windows Terminal** para cambio automático
- **Mantener sesiones tmux** para desarrollo continuo

## 🤝 Contribuir

¿Encontraste algún problema o tienes sugerencias?

1. Fork del proyecto
2. Crear branch de feature (`git checkout -b feature/mejora-wsl2`)
3. Commit de cambios (`git commit -am 'Mejorar compatibilidad WSL2'`)
4. Push al branch (`git push origin feature/mejora-wsl2`)
5. Crear Pull Request

## 🎯 Agradecimientos

Esta configuración está inspirada en el excelente trabajo de **Elliott Minns**. 

Puedes encontrar más contenido sobre desarrollo y personalización de terminales en su canal:
📺 **Dreams of Autonomy**: https://www.youtube.com/@dreamsofautonomy

Gracias por compartir conocimiento con la comunidad de desarrolladores.