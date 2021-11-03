# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# -------- Remove unused packages --------
local pkg_exists
for remove_pkg_name in ${remove_pkg_names[@]}; do
  pkg_exists=""
  pkg_exists="$(rpm -qa | grep "${remove_pkg_name}")"

  if [[ -n "${pkg_exists}" ]]; then
    echo "Removing pkg :  ${remove_pkg_name} ..."
    dnf remove -y ${remove_pkg_name}
  fi
done



# Delete cloud-init related file
SAFE_DELETE "/usr/lib/systemd/system/cloud-init-hotplugd.s*"
SAFE_DELETE "/usr/src/cloud-init"
SAFE_DELETE "/etc/cloud"
