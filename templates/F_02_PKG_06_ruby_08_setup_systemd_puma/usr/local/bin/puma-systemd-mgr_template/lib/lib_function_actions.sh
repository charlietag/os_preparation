run_action () {
  check_is_root
  local run_this_action="${1}"
  local run_this_puma_names="${2}"

  echo ""
  echo "Doing:"

  for puma_name in ${run_this_puma_names[@]}; do
    echo "      systemctl ${run_this_action} puma_${puma_name}"
    systemctl ${run_this_action} puma_${puma_name}
  done

}
