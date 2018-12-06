# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# General aliases
alias c='clear'
alias grep='grep --color=auto'
alias ll='ls -alh'
alias l='ls -lh'
#alias v='vim +"colorscheme lucid"'
alias v='vim'
alias vv='vim -u /dev/null'
alias o='cd ..'
alias oo='cd ../..'
alias ooo='cd ../../..'
alias b='cd -'

# Git aliases
alias gl='git log --graph --stat --decorate --all'
alias gls='git log --graph --stat --decorate --all --oneline'
alias glg='git log --graph --decorate --all --oneline'
alias gl-current='git log --graph --stat --decorate'
alias gls-current='git log --graph --stat --decorate --oneline'
alias glg-current='git log --graph --decorate --oneline'

alias gpush='
  echo "==================================="; \
  echo "     git status"; \
  echo "==================================="; \
  git status ; \
  echo "" ; \
  echo "==================================="; \
  echo "(git pull) && (git push) && (git push --tags)"; \
  echo "==================================="; \
  git pull && git push && git push --tags ; \
  echo "" ; \
  echo "==================================="; \
  echo "     git status"; \
  echo "==================================="; \
  git status ; \
  echo ""
  '

export HISTTIMEFORMAT='%F %T '
export HISTSIZE=5000000
umask 022

#------------------------------------------------------
#               Bash Prompt Config
#------------------------------------------------------
# Color
COLOR_RED='\[\e[1;31m\]'
COLOR_DARK_RED='\[\e[0;31m\]'
COLOR_GREEN='\[\e[1;32m\]'
COLOR_DARK_GREEN='\[\e[0;32m\]'
COLOR_YELLOW='\[\e[1;33m\]'
COLOR_DARK_YELLOW='\[\e[0;33m\]'
COLOR_BLUE='\[\e[1;34m\]'
COLOR_DARK_BLUE='\[\e[0;34m\]'
COLOR_CYAN='\[\e[1;36m\]'
COLOR_DARK_CYAN='\[\e[0;36m\]'
COLOR_MAGENTA='\[\e[1;35m\]'
COLOR_DARK_MAGENTA='\[\e[0;35m\]'
COLOR_END='\[\033[00m\]'

USER_COLOR="${COLOR_GREEN}"

# OS Version
OS_VER="$(lsb_release -irs | cut -d'.' -f-2)"



# PS1
unset PROMPT_COMMAND
PS1_TAIL="\u@\h${COLOR_END} ${COLOR_DARK_CYAN}(${OS_VER}) \t${COLOR_END} ${COLOR_BLUE}\w${COLOR_END}\n# "
PS1="${USER_COLOR}${PS1_TAIL}"

#------------------------------------------------------
#               User customized bash setting
#------------------------------------------------------
BASH_FILES="$(find $HOME/.bash_user -mindepth 1 -maxdepth 1 -type f -name "*.sh")"
if [[ -n "${BASH_FILES}" ]]; then
  for BASH_FILE in $BASH_FILES; do
    source $BASH_FILE
  done
fi

#------------------------------------------------------
#               Bash Prompt - For Git
#------------------------------------------------------
# ---Symbol---
GIT_SYMBOL_LOCAL="Ⓛ"
GIT_SYMBOL_REMOTE="Ⓡ"
#GIT_SYMBOL_LOCAL="ᄉ"
#GIT_SYMBOL_REMOTE="⚯"
GIT_SYMBOL_AHEAD="⬆"
GIT_SYMBOL_BEHIND="⬇"
GIT_SYMBOL_TAG="⚑"
GIT_SYMBOL_STASHED="☲"
GIT_SYMBOL_CHANGED="✎"
#GIT_SYMBOL_UNTRACKED="+"
GIT_SYMBOL_UNTRACKED="∿"
GIT_SYMBOL_STAGED="➜"
GIT_SYMBOL_CLEAN="✔"
GIT_SYMBOL_CONFLICT="✖"

# ---Git Prompt Setting---
GIT_PROMPT_SIMPLE_MODE=0
#GIT_PROMPT_FETCH_TIMEOUT=1
GIT_PROMPT_FETCH_TIMEOUT=5
AUTO_FETCH_REMOTE_STATUS=1

source $HOME/.bash_base/.prompt_for_git/.init.sh

