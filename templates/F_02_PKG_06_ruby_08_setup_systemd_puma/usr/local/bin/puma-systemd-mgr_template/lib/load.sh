#------------------------------------
# Variables
#------------------------------------
# --- Basic env var ---
RAILS_USER="{{current_user}}"
# RAILS_USER="rubyuser"
CURRENT_USER="$(whoami)"

# --- Other ---
SCRIPT_DEBUG_MODE=1 # [ 0 | 1 ]

# --- Global used var ---
THIS_SCRIPT="$(readlink -m $0)"
THIS_SCRIPT_NAME="$(basename "${THIS_SCRIPT}")"
THIS_PATH_BASE="$(dirname "${THIS_SCRIPT}")"

NGINX_RAILS_PATH="/etc/nginx/rails_sites"
PUMA_SERVICE_NAMES="$(cat $NGINX_RAILS_PATH/*.conf 2>/dev/null | grep 'root ' | grep -Ev '^[[:space:]]*#' | awk '{print $2}' | \
                      sed 's/ //g' | sed 's/;//g' | grep 'public' | sed 's/\/public//g' | sort | uniq | xargs -I{} basename {})"

RAILS_ENV="production"


#------------------------------------
# Define lib path
#------------------------------------
LIB="$(dirname $(readlink -m ${BASH_SOURCE[0]}))"

#------------------------------------
# Include libaries
#------------------------------------
LIB_SCRIPTS="$(ls $LIB |grep -E "^lib_[^[:space:]]+(.sh)$")"
# LIB_SCRIPTS="$(ls $LIB |grep -E "^lib_usage(.sh)$")"
for LIB_SCRIPT in $LIB_SCRIPTS
do
  . $LIB/$LIB_SCRIPT
  # echo "$LIB_SCRIPT"
done
# exit

