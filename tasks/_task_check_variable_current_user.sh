#-----------------------------------------------------------------------------------------
#Make sure variable ${current_user} is defined
#-----------------------------------------------------------------------------------------
if [[ -z "${current_user}" ]]; then
  echo "variable \"current_user\" is not defined!"
  exit
fi

#-----------------------------------------------------------------------------------------
#Make sure variable ${current_user_home} is defined
#-----------------------------------------------------------------------------------------
if [[ -z "${current_user_home}" ]]; then
  echo "variable \"current_user_home\" is not defined!"
  exit
fi

