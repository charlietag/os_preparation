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


# -------- Solve dnf known issue --------
#  Problem: conflicting requests
#  - nothing provides module(perl:5.26) needed by module perl-DBI:1.641:8010020191113222731:16b3ab4d-0.x86_64
dnf module enable perl:5.26/common -y

