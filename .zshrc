# Created by newuser for 5.9
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Inicia ssh-agent solo si no está corriendo
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi

# Añade tu clave en modo silencioso (sin mostrar errores si ya está cargada)
ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
