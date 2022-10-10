#!/bin/bash
#------------------------------------------------------
#               Bash Prompt Setting - Function
#------------------------------------------------------
# Remain '#', will be replaced by .~/bash_base/.prompt_for_git/.init.sh
PROMPT_SYM='#'

ORIGIN_PS="${PS1%\\n# }"
unset PS1



#------------------------------------------------------
#             Bash Prompt Setting - Ruby
#------------------------------------------------------
function set_ruby {
  local ruby_dark_yellow="\e[33m"
  local ruby_dark_cyan="\e[36m"
  local ruby_color_end="\033[00m"
  local rails_ver=""
  local python_prompt=""

  #if [[ -s "$HOME/.rvm/bin/rvm-prompt" ]]; then
  #  python_prompt="${ruby_dark_yellow}($($HOME/.rvm/bin/rvm-prompt))${ruby_color_end}"
  #fi
  python_prompt="${ruby_dark_yellow}(node $(node -v))${ruby_color_end}"

  local prompt_for_python="${python_prompt}"

  [[ -f "Gemfile.lock" ]] && rails_ver="$(cat Gemfile.lock |sed 's/ //g' |grep -E '^rails\([[:digit:]]+' | sed 's/(/ /g' | tr -d ')')"

  if [[ -n "${rails_ver}" ]]; then
    rails_ver="${ruby_dark_cyan}(${rails_ver})${ruby_color_end}"
    prompt_for_python="${prompt_for_python} ${rails_ver}"
  fi
  echo -e "${prompt_for_python}"
}


#------------------------------------------------------
#             Bash Prompt Setting - Start
#------------------------------------------------------
append_here="\$(set_ruby)"
PS1="${ORIGIN_PS} ${append_here}\n${PROMPT_SYM} "
