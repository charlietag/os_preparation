USER_COLOR="${COLOR_MAGENTA}"
PS1="${USER_COLOR}\u@\h${COLOR_END} ${COLOR_DARK_CYAN}\t${COLOR_END} ${COLOR_BLUE}\w${COLOR_END}\n# "

# prompt for ruby version, rails version, rvm gemset name
source $HOME/.bash_user/.prompt_for_ruby/.init.sh
