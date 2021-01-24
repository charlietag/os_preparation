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
    rvm_wrapper_puma="$(su -l ${RAILS_USER} -c "cd ${rails_path} && rvm wrapper show puma" | tail -n 1)"

    render_cp_sed ${puma_systemd_template} ${systemd_path}/puma_${puma_service_name}.service
  done

  echo ""
  systemctl daemon-reload

  # list_puma_services_zombie
  list_puma_services
}

run_option () {
  local chosen_options="${1}"
  local chosen_puma_names="${2}"

  local chosen_puma_names_arr="$(echo "${chosen_puma_names}" | sed 's/,/\n/g' | sed '/^\s*$/d' | sort -n | uniq )"

}
