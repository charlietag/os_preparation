#-----------------------------------------------------------------------------------------
# Make sure variable ${current_user} is defined
#-----------------------------------------------------------------------------------------
if [[ -z "${current_user}" ]]; then
  echo "variable \"current_user\" is not defined!"
  exit
fi

#-----------------------------------------------------------------------------------------
# add userif not exists
#-----------------------------------------------------------------------------------------
local if_current_user="$(getent passwd ${current_user})"
if [[ -z "${if_current_user}" ]]; then
  useradd ${current_user}
  local current_user_home="$(getent passwd "$current_user" | cut -d':' -f6)"
  chmod 755 ${current_user_home}
fi

echo ""
