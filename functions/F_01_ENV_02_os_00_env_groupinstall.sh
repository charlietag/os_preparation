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
dnf install -y plymouth rsyslog
systemctl enable rsyslog
systemctl restart rsyslog
set +x

echo ""

# ------------------------------------------------------------
# Main script
# ------------------------------------------------------------
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

echo "------------------------------------------------------"
echo 'Environment Groups: "Minimal Install"'
echo "------------------------------------------------------"
set -x
dnf groupinstall -y "Minimal Install"
set +x

# Same as:
# dnf install -y @"Minimal Install"


# --- Comment out, use "Minimal Install" as base ENV group
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
# Remove unused environment groups
# ------------------------------------------------------------
local installed_env_groups="$(dnf grouplist --installed)"
local unused_env_groups=("Server with GUI" "Workstation" "KDE Plasma Workspaces" "Virtualization Host" "Custom Operating System")
local is_installed
for env_group in "${unused_env_groups[@]}"; do
  is_installed="$(echo -e "${installed_env_groups}" | grep "${env_group}")"

  if [[ -n "${is_installed}" ]]; then
    echo "-------------------------"
    echo "Remove: ${env_group}"
    echo "-------------------------"
    set -x
    dnf groupremove "${env_group}"
    dnf groupinstall -y "Minimal Install"
    set +x
  fi

done
