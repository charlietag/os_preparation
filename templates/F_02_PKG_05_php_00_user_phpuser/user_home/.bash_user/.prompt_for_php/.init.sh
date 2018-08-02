#!/bin/bash
#------------------------------------------------------
#               Bash Prompt Setting - Function
#------------------------------------------------------
PROMPT_SYM='#'

ORIGIN_PS="${PS1%\\n# }"
unset PS1

#------------------------------------------------------
#             Bash Prompt Setting - PHP
#------------------------------------------------------
function set_php {
  local php_dark_magenta="\e[1;35m"
  local php_dark_cyan="\e[36m"
  local php_color_end="\033[00m"

  local laravel_ver=""
  local php_prompt="${php_dark_magenta}(php $(rpm -qi "$(rpm -qf "$(which php)")" |grep Version |awk '{print $3}'))${php_color_end}"
  local prompt_for_php="${php_prompt}"

  [[ -f "composer.lock" ]] && laravel_ver="$(cat composer.lock |grep -A 1 'laravel/framework' | grep version |grep -Eo "[[:digit:]]+.[[:digit:]]+.[[:digit:]]+")"

  if [[ -n "${laravel_ver}" ]]; then
    laravel_ver="${php_dark_cyan}(laravel ${laravel_ver})${php_color_end}"
    prompt_for_php="${prompt_for_php} ${laravel_ver}"
  fi
  echo -e "${prompt_for_php}"
}


#------------------------------------------------------
#             Bash Prompt Setting - Start
#------------------------------------------------------
append_here="\$(set_php)"
PS1="${ORIGIN_PS} ${append_here}\n${PROMPT_SYM} "
