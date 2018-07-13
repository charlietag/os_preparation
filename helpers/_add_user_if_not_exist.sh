echo "......................"
echo "add userif not exists"
echo "......................"

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
fi

echo ""
