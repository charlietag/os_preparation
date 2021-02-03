# List all available targets
#systemctl list-units --type=target --all


local default_target="multi-user.target"
local current_default_target="$(systemctl get-default | grep "${default_target}")"

if [[ -z "${current_default_target}" ]]; then

  echo "--------------------------------------------"
  echo "Set default to ${default_target}"
  echo "--------------------------------------------"
  set -x
  systemctl set-default ${default_target}
  set +x

  echo "--------------------------------------------"
  echo "Change to ${default_target}"
  echo "--------------------------------------------"
  set -x
  systemctl isolate ${default_target}
  set +x

fi
