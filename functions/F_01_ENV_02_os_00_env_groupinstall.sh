# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------------------------------
# about alias dnf => /root/bin/dnf.sh
# ------------------------------------------------------------
# Default alias is disabled in script

# --- Enable alias in script ---
# shopt -s expand_aliases

# --- (Default) Disable alias in script ---
# shopt -u expand_aliases

# --- Show current setting ---
# result should be 'off'
shopt expand_aliases

# ------------------------------------------------------------
# How to find which group package belongs to
# ------------------------------------------------------------
# Ref. https://unix.stackexchange.com/questions/236935/dnf-how-to-find-which-group-package-belongs-to
#
# dnf groupinfo '*' | sed -n '/Group:/h;/'"rsyslog"'/{x;p;x;p}'
#     Group: Core
#        rsyslog
#
# dnf groupinfo '*' | sed -n '/Group:/h;/'"Core"'/{x;p;x;p}'
#     Environment Group: Minimal Install
#        Core


# ------------------------------------------------------------
# rsyslog
# ------------------------------------------------------------
# Just in case, CentOS Stream remove these pkgs from Minimal Install in the future
# This is now included in group "Server" and "Minimal Install"
# But not installed in Vultr image
echo ""
echo "------------"
echo "rsyslog"
echo "------------"
set -x
dnf install -y rsyslog
systemctl enable rsyslog
systemctl restart rsyslog
set +x

echo ""

# ------------------------------------------------------------
# Main script
# ------------------------------------------------------------
# must run this before remove unused env groups,
# otherwise, this will raise error because of Core will be removed, and no other ENV group is installed

echo "------------------------------------------------------"
echo "Make sure use the same Installed Environment Groups"
echo "------------------------------------------------------"

# # dnf grouplist -v |grep -Ei "server |minimal"
#    Server with GUI (graphical-server-environment)
#    Minimal Install (minimal-environment)
#    Server (server-product-environment)
#
# # dnf grouplist -v |grep -Ei "server-product|minimal" | awk -F'[()]' '{print $2}'
#    minimal-environment
#    server-product-environment
local basic_env_group="Minimal Install"
echo "------------------------------------------------------"
echo "Environment Groups: \"${basic_env_group}\""
echo "------------------------------------------------------"
set -x
dnf groupinstall -y "Minimal Install"
set +x

# Same as:
# dnf install -y @"Minimal Install"


# echo "------------------------------------------------------"
# echo 'Environment Groups: "Server"'
# echo "------------------------------------------------------"
# set -x
# dnf groupinstall -y "Server"
# set +x

# Same as:
# dnf install -y @"Server"

echo ""

# ------------------------------------------------------------
# Skip if you do not want to remove unused env groups
# ------------------------------------------------------------
if [[ "${remove_unused_env_groups}" != "enable" ]]; then
  echo "remove_unused_env_groups: ${remove_unused_env_groups}"

  eval "${SKIP_SCRIPT}"
fi



# ------------------------------------------------------------
# Remove unused environment groups
# ------------------------------------------------------------
local installed_env_groups="$(dnf grouplist --installed)"

local nouse_found
local nouse_found_flag

# --- Check if noused env group is installed and make mark ---
for env_group in "${unused_env_groups[@]}"; do
  nouse_found="$(echo -e "${installed_env_groups}" | grep "${env_group}")"
  if [[ -n "${nouse_found}" ]]; then
    nouse_found_flag=1
  fi
done

# --- If noused env group is installed: ---
#   install group: Server, before remove unused env group,
#   otherwise-> failed to removed.
#   because these env groups will contain protected package: dnf, yum, sudo

if [[ ${nouse_found_flag} -ne 1 ]]; then
  echo "No unused environment groups found ."

  eval "${SKIP_SCRIPT}"
fi

echo "------------------------------------------------------"
echo 'Environment Groups: "Server"'
echo "------------------------------------------------------"
set -x
dnf groupinstall -y "Server"
set +x

# --- Start to remove unused env groups ---
for env_group in "${unused_env_groups[@]}"; do
  nouse_found="$(echo -e "${installed_env_groups}" | grep "${env_group}")"

  if [[ -n "${nouse_found}" ]]; then
    echo "-------------------------"
    echo "Remove: ${env_group}"
    echo "-------------------------"
    set -x
    dnf groupremove -y "${env_group}"
    set +x
  fi
done

# --- 1. if unused env groups found, 2. after removed unused env groups: ---
#   install basic env groups again, in case useful packages are also removed

# To make sure required packages is not removed, while removing unused ENV groups, install env group "Minimal Install" again
echo "------------------------------------------------------"
echo 'Install ENV group again: "Minimal Install"'
echo "------------------------------------------------------"
set -x
dnf groupinstall -y "Minimal Install"
set +x

echo "------------------------------------------------------"
echo 'Environment Groups: "Server"'
echo "------------------------------------------------------"
set -x
dnf groupinstall -y "Server"
set +x

