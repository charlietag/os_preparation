list_puma_services () {
  # -------------------------------------------------------
  # Available puma services
  # -------------------------------------------------------
  list_puma_services_available

  # -------------------------------------------------------
  # List Puma systemd services
  # -------------------------------------------------------
  list_puma_services_systemd

  # -------------------------------------------------------
  # List running puma process
  # -------------------------------------------------------
  list_puma_services_processes

  # -------------------------------------------------------
  # List Puma Zombie Processes
  # -------------------------------------------------------
  list_puma_services_zombie
}

generate_systemd_config () {
  check_is_root

  # ---------------------------------------------------------------
  local rvm_wrapper_puma
  local rails_path
  local systemd_path="/usr/lib/systemd/system"
  local puma_systemd_template="${THIS_SCRIPT}_template/puma.service"

  # ---------------------------------------------------------------
  echo "Removing old configs..."
  SAFE_DELETE "${systemd_path}/puma_*.service"
  echo ""

  # ---------------------------------------------------------------
  echo "Generating..."
  echo ""

  for puma_service_name in ${PUMA_SERVICE_NAMES[@]}; do

    rails_path="/home/${RAILS_USER}/rails_sites/${puma_service_name}"
    check_if_gem_wrappers_installed "${rails_path}"

    rvm_wrapper_puma="$(su -l ${RAILS_USER} -c "cd ${rails_path} && gem wrapper show puma" | tail -n 1)"

    render_cp_sed ${puma_systemd_template} ${systemd_path}/puma_${puma_service_name}.service
  done

  echo ""
  systemctl daemon-reload

  list_puma_services_zombie
  # list_puma_services
}

# ----------------------
# This is run, after check_option
# So no need to consider many special cases here. It's been checked at check_option
# ----------------------
run_option () {
  local this_chosen_puma_names

  # -------------------------------------
  # -h -l -g
  # there should be only one argv given
  # -------------------------------------

  # if [[ "${THIS_OPTION}" = "h" ]]; then
  #   usage
  #   exit
  # fi
  #
  # if [[ "${THIS_OPTION}" = "l" ]]; then
  #   list_puma_services
  #   exit
  # fi
  #
  # if [[ "${THIS_OPTION}" = "g" ]]; then
  #   generate_systemd_config
  #   exit
  # fi

  case "${THIS_OPTION}" in
    h)
      usage
      exit
      ;;

    l)
      list_puma_services
      exit
      ;;

    g)
      generate_systemd_config
      exit
      ;;

  esac

  # -------------------------------------
  # -i -a
  # should be works with actions, already checked by check_option
  # -------------------------------------
  case "${THIS_SERVICE}" in
    a)
      this_chosen_puma_names="${PUMA_SERVICE_NAMES}"
      ;;

    i)
      this_chosen_puma_names="${CHOSEN_PUMA_NAMES_ARR}"
      ;;

  esac


  # -------------------------------------
  # -s -p -r -e -d -t
  # should be works with services, already checked by check_option
  # -------------------------------------
  # THIS_ACTION
  case "${THIS_ACTION}" in
    s)
      run_action "start" "${this_chosen_puma_names}"
      exit
      ;;

    p)
      run_action "stop" "${this_chosen_puma_names}"
      exit
      ;;

    r)
      run_action "reload" "${this_chosen_puma_names}"
      exit
      ;;

    e)
      run_action "enable" "${this_chosen_puma_names}"
      exit
      ;;

    d)
      run_action "disable" "${this_chosen_puma_names}"
      exit
      ;;

    t)
      run_action "restart" "${this_chosen_puma_names}"
      exit
      ;;

  esac

}
