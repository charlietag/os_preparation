#------------------------
# start add user for no ssh priv
#------------------------
local no_ssh_group_name="no-ssh-group"
local if_no_ssh_group="$(getent group ${no_ssh_group_name})"

if [[ -z "${if_no_ssh_group}" ]]; then
  groupadd ${no_ssh_group_name}
fi

_helper_add_user_if_not_exist

# add user into group no-ssh-group
usermod -a -G ${no_ssh_group_name} ${current_user}

# remove user from group no-ssh-group
#gpasswd -d ${current_user} ${no_ssh_group_name}

#------------------------
# check if current_user exists
#------------------------
_helper_check_variable_current_user


