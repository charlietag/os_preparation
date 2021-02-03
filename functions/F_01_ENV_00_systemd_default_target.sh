# --- List all available targets ---
#systemctl list-units --type=target --all

# --- List target dependencies ---
# # systemctl list-dependencies multi-user.target
# # systemctl list-dependencies multi-user.target  --reverse
# multi-user.target
# ● └─graphical.target
#
# systemctl list-dependencies graphical.target
# systemctl list-dependencies graphical.target  --reverse
# graphical.target
#
# # --- Create a systemd target ---
# # Ref. https://unix.stackexchange.com/questions/301987/how-to-create-a-systemd-target
# find /usr/lib/systemd/system |grep multi
# /usr/lib/systemd/system/multi-user.target.wants
# /usr/lib/systemd/system/multi-user.target.wants/dbus.service
# /usr/lib/systemd/system/multi-user.target.wants/getty.target
# /usr/lib/systemd/system/multi-user.target.wants/systemd-ask-password-wall.path
# /usr/lib/systemd/system/multi-user.target.wants/systemd-logind.service
# /usr/lib/systemd/system/multi-user.target.wants/systemd-update-utmp-runlevel.service
# /usr/lib/systemd/system/multi-user.target.wants/systemd-user-sessions.service
# /usr/lib/systemd/system/multi-user.target.wants/plymouth-quit-wait.service
# /usr/lib/systemd/system/multi-user.target.wants/plymouth-quit.service
# /usr/lib/systemd/system/multi-user.target
# /usr/lib/systemd/system/multipathd.service
# /usr/lib/systemd/system/multipathd.socket



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
