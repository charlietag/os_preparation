#!/bin/bash
#------------------------------------------------------
#               Bash Prompt Setting - Function
#------------------------------------------------------
PROMPT_SYM='$'
if [[ $UID -eq 0 ]]; then
  PROMPT_SYM='#'
else
  if [[ -n "${USER_COLOR}" ]]; then
   PROMPT_SYM="${USER_COLOR}\$${COLOR_END}"
 fi
fi

ORIGIN_PS="${PS1%\\n# }"
unset PROMPT_COMMAND PS1

function set_bash_prompt {
  local append_here="$1"
  bash_prompt_template="${ORIGIN_PS} ${append_here}\n${PROMPT_SYM} "
  echo "${bash_prompt_template}"
}

#------------------------------------------------------
#             Bash Prompt Setting - Git
#------------------------------------------------------
function older_than_minutes {
  local this_file="$1"
  local this_timeout="$2"
  local matches=""

  if [ -z "${this_timeout}" ]
  then
    this_timeout=10
  fi

  matches=$(find "${this_file}" -mmin +"${this_timeout}" 2> /dev/null)
  if [[ -n "$matches" ]]
  then
    return 0
  else
    return 1
  fi
}

#function async_run {
#  eval "$@" &>/dev/null &
#}
# &>/dev/null 
#abbreviation of 
# 2>&1 >/dev/null
GIT_FETCH_LOCK_FILE="$HOME/.bash_base/.prompt_for_git/.git_fetch_lock_file"
function async_git_fetch {
  nohup &>/dev/null flock -n $GIT_FETCH_LOCK_FILE -c "git fetch --quiet 2>/dev/null" &
}


function check_upstream {
  local git_prompt_fetch_timeout="${GIT_PROMPT_FETCH_TIMEOUT}"

  local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
  local fetch_head="$repo/.git/FETCH_HEAD"
  # Fetch repo if local is stale for more than $GIT_FETCH_TIMEOUT minutes
  if [ ! -e "$fetch_head" ] || $(older_than_minutes "$fetch_head" "$git_prompt_fetch_timeout")
  then
    if [ ! -z "$(git remote show 2>/dev/null)" ]
    then
      #(
      #  async_run "git fetch --quiet"
      #  disown -h
      #)
      async_git_fetch
    fi
  fi
}
function git_track {
  local git_track=""
  local gitstatus=$( git status --untracked-files=all --porcelain --branch 2>/dev/null )
  # if the status is fatal, exit now
  [[ "$?" -ne 0 ]] && exit 0

  local num_staged=0
  local num_changed=0
  local num_untracked=0
  local num_conflicts=0
  while IFS='' read -r line || [[ -n "$line" ]]; do
    status=${line:0:2}
    while [[ -n $status ]]; do
      case "$status" in
        #two fixed character matches, loop finished
        \#\#) local branch_line="${line/\.\.\./^}"; break ;;
        \?\?) ((num_untracked++)); break ;;
        U?) ((num_conflicts++)); break;;
        ?U) ((num_conflicts++)); break;;
        DD) ((num_conflicts++)); break;;
        AA) ((num_conflicts++)); break;;
        #two character matches, first loop
        ?M) ((num_changed++)) ;;
        ?D) ((num_changed++)) ;;
        ?\ ) ;;
        #single character matches, second loop
        U) ((num_conflicts++)) ;;
        \ ) ;;
        *) ((num_staged++)) ;;
      esac
      status=${status:0:(${#status}-1)}
    done
  done <<< "$gitstatus"

  # ahead / behind----
  local branch_fields=""
  local remote_fields=""
  IFS="^" read -ra branch_fields <<< "${branch_line/\#\# }"
  if [[ "${#branch_fields[@]}" -ne 1 ]]
  then
    IFS="[,]" read -ra remote_fields <<< "${branch_fields[1]}"
    for remote_field in "${remote_fields[@]}"; do
      if [[ "$remote_field" == "ahead "* ]]; then
        num_ahead="${remote_field:6}"
        num_ahead="${num_ahead// }"
      fi
      if [[ "$remote_field" == "behind "* ]] || [[ "$remote_field" == " behind "* ]]; then
        num_behind="${remote_field:7}"
        num_behind="${num_behind// }"
      fi
    done
  fi
  
  [[ $num_ahead -ne 0 ]] && git_track="${git_track}${COLOR_YELLOW}${GIT_SYMBOL_AHEAD}${num_ahead}${COLOR_END} "
  [[ $num_behind -ne 0 ]] && git_track="${git_track}${COLOR_YELLOW}${GIT_SYMBOL_BEHIND}${num_behind}${COLOR_END} "
  # ahead / behind----

  local num_stashed=$(git stash list 2>/dev/null |wc -l)
  local clean=0
  if (( num_changed == 0 && num_staged == 0 && num_untracked == 0 && num_stashed == 0 && num_conflicts == 0)) ; then
    clean=1
  fi
  [[ $num_staged -ne 0 ]] && git_track="${git_track}${COLOR_MAGENTA}${GIT_SYMBOL_STAGED}${num_staged}${COLOR_END} "
  [[ $num_changed -ne 0 ]] && git_track="${git_track}${COLOR_RED}${GIT_SYMBOL_CHANGED}${num_changed}${COLOR_END} "
  [[ $num_untracked -ne 0 ]] && git_track="${git_track}${COLOR_RED}${GIT_SYMBOL_UNTRACKED}${num_untracked}${COLOR_END} "
  [[ $num_conflicts -ne 0 ]] && git_track="${git_track}${COLOR_RED}${GIT_SYMBOL_CONFLICT}${num_conflicts}${COLOR_END} "
  [[ $clean -ne 0 ]] && git_track="${git_track}${COLOR_GREEN}${GIT_SYMBOL_CLEAN}${COLOR_END} "

  echo -e "${git_track}"
}

function git_local_remote {
  if [ -z "$(git remote show 2>/dev/null)" ]
  then
    #echo -e "${COLOR_DARK_BLUE}Local${COLOR_END} "
    echo -e "${COLOR_DARK_BLUE}${GIT_SYMBOL_LOCAL}${COLOR_END} "
  else
    #echo -e "${COLOR_YELLOW}Remote${COLOR_END} "
    echo -e "${COLOR_YELLOW}${GIT_SYMBOL_REMOTE}${COLOR_END} "
  fi
}

function git_branch {
  local git_branch="$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1)/")"

  # File changed, untracked
  if [[ -z "$(git status 2>/dev/null | tail -n1 | grep -E "nothing to commit, working[[:print:]]*clean" )" ]]
  then
    echo -e "${COLOR_RED}${git_branch}${COLOR_END} "
  else
    echo -e "${COLOR_GREEN}${git_branch}${COLOR_END} "
  fi
}

function git_last_commit {
  local git_last_commit=$(git log --pretty=format:%ar -1 2>/dev/null)
  echo -e "${COLOR_DARK_YELLOW}(${git_last_commit})${COLOR_END} "
}

function git_is_on_tag {
  local git_is_on_tag="$(git describe --exact-match --tags $(git rev-parse HEAD 2>/dev/null) 2>/dev/null)"
  if [[ ! -z "${git_is_on_tag}" ]]
  then
    echo -e "${COLOR_DARK_GREEN}(${GIT_SYMBOL_TAG}${git_is_on_tag})${COLOR_END} "
  fi
}

function git_stash {
  local git_stash_count="$(git stash list 2>/dev/null |wc -l)"
  if [ "${git_stash_count}" -ne 0 ] 
  then
    echo -e "${COLOR_RED}${GIT_SYMBOL_STASHED}${git_stash_count}${COLOR_END} "
  fi
}

function git_info_init {
  #Async fetch git
  if [[ $AUTO_FETCH_REMOTE_STATUS -eq 1 ]]
  then
    check_upstream
  fi

  #git info
  local getinfo=""
  if [[ $GIT_PROMPT_SIMPLE_MODE -eq 1 ]]
  then
    getinfo="$(git_branch)$(git_last_commit)"
  else
    getinfo="$(git_branch)$(git_is_on_tag)$(git_last_commit)$(git_local_remote)$(git_stash)$(git_track)"
  fi

  # Return git info to PS1
  echo -e "${getinfo}"
}

#------------------------------------------------------
#             Bash Prompt Setting - Start
#------------------------------------------------------
function is_git {
  if $(git rev-parse --git-dir >/dev/null 2>/dev/null)
  then
    PS1="$(set_bash_prompt "$(git_info_init)")"
  else
    PS1="$(set_bash_prompt)"
  fi
}

if [ -z "${PROMPT_COMMAND}" ] || [ -z "${PS1}" ]
then
  PROMPT_COMMAND='is_git'
fi
