# Establecer el directorio donde queremos almacenar zinit y plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Descargar Zinit, si no está presente aún
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Cargar zinit
source "${ZINIT_HOME}/zinit.zsh"

# Agregar plugins de zsh
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Agregar snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::node
zinit snippet OMZP::npm
zinit snippet OMZP::nvm
zinit snippet OMZP::sdk
zinit snippet OMZP::ssh-agent

# Cargar completions
autoload -Uz compinit && compinit

# Cargar zsh-syntax-highlighting al final, después de compinit
zinit light zsh-users/zsh-syntax-highlighting

# Opcional: completions de fzf-tab integrados en compinit
zinit cdreplay -q

# Establecer locale
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Configuración de keychain para manejar el agente SSH
# Asegúrate de tener keychain instalado: sudo pacman -S keychain
eval "$(keychain --eval ~/.ssh/id_ed25519 --quiet)"

# Para personalizar el prompt, ejecuta `p10k configure` o edita ~/.p10k.zsh.
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Atajos de teclado
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Historial
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Estilizado de completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Alias
alias ls='ls --color'

# Integraciones de shell
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Instalacion de nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
