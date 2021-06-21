check_is_root () {
  if [[ "${CURRENT_USER}" != "root" ]]; then
    echo "Must run as \"root\""
    echo ""
    exit
  fi
}

check_rvm_installation () {
  local rvm_bin="/home/${RAILS_USER}/.rvm/bin/rvm"
  if [[ ! -s "${rvm_bin}" ]]; then
    echo "\"rvm\" is not installed yet for user \"${RAILS_USER}\" !"
    echo ""
    exit
  fi
}

check_if_gem_wrappers_installed () {
  local rails_path="$1"
  local gem_dir="$(su -l ${RAILS_USER} -c "cd ${rails_path} && gem env gemdir" | tail -n 1)/gems"
  local gem_wrappers_exits="$(ls ${gem_dir} | grep 'gem-wrappers')"
  if [[ -z "${gem_wrappers_exits}" ]]; then
    echo ""
    echo "--------------------------------------------"
    echo "Gem 'gem-wrappers' not found under ${rails_path}"
    echo "command: gem install gem-wrappers"
    su -l ${RAILS_USER} -c "cd ${rails_path} && gem install gem-wrappers"
    echo "--------------------------------------------"
    echo ""
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

check_puma_service_unit_exists () {
  local puma_unit_file
  local puma_unit_file_not_found=0
  local puma_unit_err_msg=""

  for puma_service_name in ${PUMA_SERVICE_NAMES[@]}; do
    puma_unit_file="/usr/lib/systemd/system/puma_${puma_service_name}.service"
    if [[ ! -s ${puma_unit_file} ]]; then
      puma_unit_file_not_found=1
      puma_unit_err_msg="${puma_unit_err_msg}\n(WARN) not found: ${puma_unit_file}"
    fi
  done

  if [[ ${puma_unit_file_not_found} -eq 1 ]]; then
    echo "------------------------------------------"
    echo "Puma service units not found:"
    echo "------------------------------------------"
    echo -e "${puma_unit_err_msg}"
    show_gen_help_no_exit
    echo "------------------------------------------"
    echo ""
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
      err_msg_tmp="${err_msg_tmp}\ngem \"${required_gem}\" not installed:             ${rails_path_gemfile}\n"
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
  local debug_option_msg="\n-------- debug: entered argv --------\n"

  # -------------------------------------------------------------------------------
  # check other options
  # -------------------------------------------------------------------------------
  local this_option_count="$(echo -e "${THIS_OPTION}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  debug_option_msg="${debug_option_msg}option: ${this_option_count}\n"
  debug_option_msg="${debug_option_msg}${THIS_OPTION}\n\n"


  # -------------------------------------------------------------------------------
  # check actions
  # -------------------------------------------------------------------------------
  local this_action_count="$(echo -e "${THIS_ACTION}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  debug_option_msg="${debug_option_msg}action: ${this_action_count}\n"
  debug_option_msg="${debug_option_msg}${THIS_ACTION}\n\n"


  # -------------------------------------------------------------------------------
  # check services
  # -------------------------------------------------------------------------------
  local this_service_count="$(echo -e "${THIS_SERVICE}" | sed '/^\s*$/d' | wc -l)"

  # --- Debug Use ---
  debug_option_msg="${debug_option_msg}service: ${this_service_count}\n"
  debug_option_msg="${debug_option_msg}${THIS_SERVICE}\n"

  # --- Debug Use ---
  if [[ -n "${CHOSEN_PUMA_NAMES_ARR}" ]]; then
    debug_option_msg="${debug_option_msg}=>\n${CHOSEN_PUMA_NAMES_ARR}\n"
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

  # -s -p -r -e -d -t
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

    # Check puma names (OPTARG -> $CHOSEN_PUMA_NAMES_ARR)
    # while using getopts, if colon is used, such as 'i:',
    # then -i xxx => xxx must be specified,
    # otherwise:
    #            -i       => this will not be activated
    #            $OPTARG  => this will be empty
    if [[ "${THIS_SERVICE}" = "i" ]]; then
      check_puma_service_exists
    fi
  fi



}

check_puma_service_exists () {
  local puma_name_not_found=0
  local check_puma_name

  for puma_name in ${CHOSEN_PUMA_NAMES_ARR[@]}; do
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
