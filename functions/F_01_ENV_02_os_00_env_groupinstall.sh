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
# dnf groupinfo '*' | sed -n '/Group:/h;/'"rsyslog"'/{x;p;x;p}'
#     Group: Core
#        rsyslog
#
# dnf groupinfo '*' | sed -n '/Group:/h;/'"Core"'/{x;p;x;p}'
#     Environment Group: Minimal Install
#        Core


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
echo 'dnf groupinstall -y "Minimal Install"'
echo "------------------------------------------------------"
dnf groupinstall -y "Minimal Install"

# Just in case, CentOS Stream remove these pkgs from Minimal Install in the future
dnf install -y plymouth rsyslog

# Same as:
# dnf install -y @"Minimal Install"


echo "------------------------------------------------------"
echo 'dnf groupinstall -y "Server"'
echo "------------------------------------------------------"
dnf groupinstall -y "Server"

# Same as:
# dnf install -y @"Server"

echo ""
