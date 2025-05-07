#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

ln -s

# link() {
#   if [ -L "~/$1" ]; then
#     echo "~/$1 already linked"
#     return
#   fi

#   if [ -f "~/$1" ]; then
#     ln -s "$SCRIPT_DIR/$1" ~/$1
#   fi

#   ln -s "$SCRIPT_DIR/$1" ~/$1
# }

# link ".zshrc"
# link ".tmux.conf"
