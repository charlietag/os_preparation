# List all available targets
#systemctl list-units --type=target --all


local default_target="multi-user.target"
local current_default_target="$(systemctl get-default | grep "${default_target}")"

if [[ -z "${current_default_target}" ]]; then
  echo "--------------------------------------------"
  echo "Change to ${default_target}"
  echo "--------------------------------------------"
  echo "systemctl isolate ${default_target}"
  systemctl isolate ${default_target}

  echo "--------------------------------------------"
  echo "Set default to ${default_target}"
  echo "--------------------------------------------"
  echo "systemctl set-default ${default_target}"
  systemctl set-default ${default_target}
fi
