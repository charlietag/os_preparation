check_is_root () {
  if [[ "${CURRENT_USER}" != "root" ]]; then
    echo "Must run as \"root\""
    exit
  fi
}

check_nginx_conf_exists () {
  if [[ -z "${PUMA_SERVICE_NAMES}" ]]; then
    echo "(WARN) No Nginx configs for rails sites found!"
    echo ""
    echo "Please check:"
    echo "  ${NGINX_RAILS_PATH}/*.conf"
    exit
  fi
}

check_required_dependencies () {
  # ------------------------------------
  # function var
  # ------------------------------------
  local err_msg_found
  local err_msg
  local err_msg_tmp

  local rails_path
  local rails_path_gemfile

  local required_gem="sd_notify"
  local required_gem_found

  local puma_prod_conf

  # ------------------------------------
  # Start to check
  # ------------------------------------
  for puma_service_name in ${PUMA_SERVICE_NAMES[@]}; do
    err_msg_found=0
    err_msg_tmp=""

    rails_path="/home/${RAILS_USER}/rails_sites/${puma_service_name}"


    # ------------------------------------
    # Check systemd type=notify gem
    # ------------------------------------
    rails_path_gemfile="${rails_path}/Gemfile"
    required_gem_found="$(cat ${rails_path_gemfile}.lock 2>/dev/null | grep -Ev '^[[:space:]]*#' | grep "${required_gem}")"

    if [[ -z "${required_gem_found}" ]]; then
      err_msg_found=1
      err_msg_tmp="${err_msg_tmp}\ngem ${required_gem} not installed:             ${rails_path_gemfile}\n"
    fi

    # ------------------------------------
    # Check puma config
    # ------------------------------------
    puma_prod_conf="${rails_path}/config/puma/production.rb"
    if [[ ! -s "${puma_prod_conf}" ]]; then
      err_msg_found=1
      err_msg_tmp="${err_msg_tmp}\npuma config for production not found:    ${puma_prod_conf}\n"
    fi


    # ------------------------------------
    # Check msg combine
    # ------------------------------------
    if [[ ${err_msg_found} -eq 1 ]]; then
      err_msg_tmp="-----------------------------------------\n${rails_path}\n-----------------------------------------${err_msg_tmp}"
      err_msg="${err_msg}\n${err_msg_tmp}\n"
    fi
  done

  if [[ -n "${err_msg}" ]]; then
    echo -e "${err_msg}"
    exit
  fi

}

check_option () {
  local chosen_options="${1}"
  local chosen_puma_names="${2}"

  local debug_option_msg="\n-------- debug: entered argv --------\n"

  local chosen_puma_names_arr="$(echo "${chosen_puma_names}" | sed 's/,/\n/g' | sed '/^\s*$/d' | sort -n | uniq )"

  # -------------------------------------------------------------------------------
  # check other options
  # -------------------------------------------------------------------------------
  local allowed_options="h|l|g"

  local this_option="$(echo "${chosen_options}" | grep -Eo "${allowed_options}")"
  local this_option_count="$(echo -e "${this_option}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  # echo "this_option: ${this_option_count}"
  # echo -e "${this_option}"
  debug_option_msg="${debug_option_msg}option: ${this_option_count}\n"
  debug_option_msg="${debug_option_msg}${this_option}\n\n"


  # -------------------------------------------------------------------------------
  # check actions
  # -------------------------------------------------------------------------------
  local allowed_actions="t|p|r|e|d"

  local this_action="$(echo "${chosen_options}" | grep -Eo "${allowed_actions}")"
  local this_action_count="$(echo -e "${this_action}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  # echo "this_action: ${this_action_count}"
  # echo -e "${this_action}"
  debug_option_msg="${debug_option_msg}action: ${this_action_count}\n"
  debug_option_msg="${debug_option_msg}${this_action}\n\n"


  # -------------------------------------------------------------------------------
  # check services
  # -------------------------------------------------------------------------------
  local allowed_services="i|a"

  local this_service="$(echo "${chosen_options}" | grep -Eo "${allowed_services}")"
  local this_service_count="$(echo -e "${this_service}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  # echo "this_service: ${this_service_count}"
  # echo -e "${this_service}"

  debug_option_msg="${debug_option_msg}service: ${this_service_count}\n"
  debug_option_msg="${debug_option_msg}${this_service}\n"

  # --- Debug Use ---
  if [[ -n "${chosen_puma_names_arr}" ]]; then
    debug_option_msg="${debug_option_msg}=>\n${chosen_puma_names_arr}\n"
  fi
  debug_option_msg="${debug_option_msg}-------- debug end --------\n"

  if [[ $SCRIPT_DEBUG_MODE -ne 1 ]]; then
    debug_option_msg=""
  fi

  # -------------------------------------------------------------------------------
  # Final Check
  # -------------------------------------------------------------------------------
  # -h -l -g
  if [[ ${this_option_count} -gt 1 ]]; then
    echo -e "${debug_option_msg}"
    show_help_and_exit
  fi

  if [[ ${this_option_count} -eq 1 ]]; then
    if [[ ${this_action_count} -ne 0 ]]; then
      echo -e "${debug_option_msg}"
      show_help_and_exit
    fi
    if [[ ${this_service_count} -ne 0 ]]; then
      echo -e "${debug_option_msg}"
      show_help_and_exit
    fi
  fi

  # -t -p -r -e -d
  if [[ ${this_action_count} -gt 1 ]]; then
    echo -e "${debug_option_msg}"
    show_help_and_exit
  fi

  if [[ ${this_action_count} -eq 1 ]]; then
    if [[ ${this_service_count} -ne 1 ]]; then
      echo "<service> is not given !"

      echo -e "${debug_option_msg}"
      show_help_and_exit
    fi
  fi

  # -i -a
  if [[ ${this_service_count} -gt 1 ]]; then
    echo -e "${debug_option_msg}"
    show_help_and_exit
  fi

  if [[ ${this_service_count} -eq 1 ]]; then
    if [[ ${this_action_count} -ne 1 ]]; then
      echo "<action> is not given !"

      echo -e "${debug_option_msg}"
      show_help_and_exit
    fi

    # Check puma names (OPTARG -> $chosen_puma_names_arr)
    # while using getopts, if colon is used, such as 'i:',
    # then -i xxx => xxx must be specified,
    # otherwise:
    #            -i       => this will not be activated
    #            $OPTARG  => this will be empty
    if [[ "${this_service}" = "i" ]]; then
      check_puma_service_exists "${chosen_puma_names_arr}"
    fi
  fi



}

check_puma_service_exists () {
  local chosen_puma_names_arr="${1}"
  local puma_name_not_found=0
  local check_puma_name

  for puma_name in ${chosen_puma_names_arr[@]}; do
    check_puma_name="$(echo -e "${PUMA_SERVICE_NAMES}" | grep "^${puma_name}$")"
    if [[ -z "${check_puma_name}" ]]; then
      puma_name_not_found=1
      echo "given name cannot be recognized: ${puma_name}"
    fi
  done

  if [[ ${puma_name_not_found} -eq 1 ]]; then
    show_list_and_exit
  fi
}
