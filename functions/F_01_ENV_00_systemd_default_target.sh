# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable


# -------------------------------------------------------------------------------------
# Main
# -------------------------------------------------------------------------------------
local current_default_target="$(systemctl get-default)"
local check_target="$(echo ${current_default_target} | grep "${default_target}")"

if [[ -z "${check_target}" ]]; then
  if [[ "${wrong_default_target_found}" = "force" ]]; then
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
  else
    echo "--------------------------------------------"
    echo "You are under \"${current_default_target}\""
    echo "--------------------------------------------"
    echo "It is highly recommended to:"
    echo ""
    echo "    \"REINSTALL Whole CentOS using \"Minimal Install\""
    echo ""
    echo "Or please be sure to set default target to \"${default_target}\" then reboot first"
    echo ""
    echo "-- HOW TO: --"
    echo "1. systemctl set-default multi-user"
    echo "2. reboot"
    echo '3. dnf groupinstall "Minimal Install" (If this is not working, try also: dnf groupinstall "Server")'
    echo "4. dnf groupremove 'Server with GUI'"
    echo "5. reboot"
    echo "6. you can start with os_prepation now"
    echo ""

    exit
  fi


fi


# -------------------------------------------------------------------------------------
# Reference
# -------------------------------------------------------------------------------------
# --- List all available targets ---
#systemctl list-units --type=target --all

# --- List target dependencies ---
# # systemctl list-dependencies multi-user.target
# # systemctl list-dependencies multi-user.target  --reverse
# multi-user.target
# ● └─graphical.target
#
# # systemctl list-dependencies graphical.target
# # systemctl list-dependencies graphical.target  --reverse
#     graphical.target
#
# # --- Create a systemd target ---
# # Ref. https://unix.stackexchange.com/questions/301987/how-to-create-a-systemd-target
# # find /usr/lib/systemd/system |grep multi
#     /usr/lib/systemd/system/multi-user.target.wants
#     /usr/lib/systemd/system/multi-user.target.wants/dbus.service
#     /usr/lib/systemd/system/multi-user.target.wants/getty.target
#     /usr/lib/systemd/system/multi-user.target.wants/systemd-ask-password-wall.path
#     /usr/lib/systemd/system/multi-user.target.wants/systemd-logind.service
#     /usr/lib/systemd/system/multi-user.target.wants/systemd-update-utmp-runlevel.service
#     /usr/lib/systemd/system/multi-user.target.wants/systemd-user-sessions.service
#     /usr/lib/systemd/system/multi-user.target.wants/plymouth-quit-wait.service
#     /usr/lib/systemd/system/multi-user.target.wants/plymouth-quit.service
#     /usr/lib/systemd/system/multi-user.target
#     /usr/lib/systemd/system/multipathd.service
#     /usr/lib/systemd/system/multipathd.socket

# ref. /etc/inittab
# multi-user.target: analogous to runlevel 3
# graphical.target: analogous to runlevel 5

# If in graphical.target
#   there is boot screen with rotating activity icon spinning,
# If eager to remove this spinning icon:
# Success:
#    1. systemctl set-default multi-user
#    2. reboot
#    3. dnf groupremove 'Server with GUI'
#    4. done
# Fail:
#    1. systemctl set-default multi-user
#    2. systemctl isolate multi-user
#    3. dnf groupremove 'Server with GUI'
#    4. reboot
#    5. failed
#    6. dnf remove plymouth -y
#    7. failed again
#     ->  Because if no reboot is triggered, spinning icon will not be able to removed
#     ->  Even some packages, some libs, cannot be fully removed
#    8. remove rhgb quiet from /etc/default/grub ; grub2-mkconfig -o /boot/grub2/grub.cfg
#    9. sucess, but not clean
