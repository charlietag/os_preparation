# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ###########################################################
# @AppStream
# For using dnf module (obey variable name rules)
# ###########################################################
# variable defining rules:
#                            local pkgname_dnf_module_version="{stream}"
# try look up version(stream) this way:
#                                         dnf module list pkgname #
# Sample:
#         local nginx_dnf_module_version="1.18"
# ----------------------------------------------------------



# Make sure appstream needs to be activated
if [[ "${use_centos_app_stream}" != "enable" ]]; then
  echo "------------------------------------------------------------------"
  echo "Use CentOS AppStream"
  echo "------------------------------------------------------------------"
  echo "use_centos_app_stream: ${use_centos_app_stream}"
  echo "skip..."
  echo ""
  echo ""
  echo ""
  echo "------------------------------------------------------------------"
  eval "${SKIP_SCRIPT}"
fi

#-----------------------------------------------------------------------------------------
# Enable dnf modules
#-----------------------------------------------------------------------------------------

# sample info:
# dnf module list inginx
# -> Name, Stream, Profiles, Summary
# -> nginx, 1.18, common, nginx webserver

# (name)
# local module
# (stream)
# local version

echo "==================================================="
echo "Enable the following module:version if not setup yet"
echo "==================================================="
echo "${dnf_enabled_modules_versions}"

local module_arr
local module_version_arr

local enabled_modules="$(dnf module list $(echo "${dnf_enabled_modules_versions}" | sed ':a;N;$!ba;s/\n/ /g') --enabled 2>&1 | grep -E "$(echo "${dnf_enabled_modules_versions}" | cut -d':' -f1 | sed ':a;N;$!ba;s/\n/|/g')" | awk '{print $1}')"

for module_version in ${dnf_enabled_modules_versions[@]}; do

  # Actually, if nginx 1.14 is installed, then dnf will not allow you to install other version nginx, or  do a nginx module reset
  # if ! $(dnf module list ${module_version} --enabled >/dev/null 2>/dev/null) ; then
  module="$(echo ${module_version} | cut -d':' -f1)"
  if [[ -z "$(echo "${enabled_modules}" | grep "${module}")" ]] ; then

    # For RHEL 9 (Lots of module does not exists yet)
    if [[ -n "$(dnf module list ${module_version} 2>/dev/null >/dev/null && echo "module:version exists")" ]]; then
      echo "==================================================="
      echo "@AppStream"
      echo "Enabling module : ${module_version}"
      echo "==================================================="
      module_arr="${module_arr} $(echo ${module_version} | cut -d':' -f1)"
      module_version_arr="${module_version_arr} ${module_version}"

      # ----------------
      # used variable defined
      # ----------------
      # ex: nginx
      # module="$(echo ${module_version} | cut -d':' -f1)"
      # ex: 1.18
      # version="$(echo ${module_version} | cut -d':' -f2)"
      # ex: nginx:1.18
      # ${module_version}
      # echo "${module_version}"
      # ----------------
      # dnf module reset ${module} -y
      # dnf module enable ${module_version} -y
      # echo ""
      # echo ""
      # echo ">>>>>>>>>>>>>>>>"
      # echo "Enabled module:"
      # echo ">>>>>>>>>>>>>>>>"
      # dnf module list ${module} --enabled | grep -B 1 ${module}
      # echo "--------------------------------------------------"
      # echo ""
      # echo ""
    else
      echo "==================================================="
      echo "This does not exist in ==> $(cat /etc/os-release |grep -i pretty_name | cut -d'"' -f2 | grep -Eo "[[:print:]]+[[:digit:]\.]+")  "
      echo "Module : ${module_version}"
      echo "==================================================="


    fi

    # -----------> do module reset / enable one time only
  fi

done

if [[ -z "${module_arr}" ]]; then
  echo "--------------------------------------------------"
  echo "All modules have been enabled ORIGINALLY:"
  echo "--------------------------------------------------"
  echo "${dnf_enabled_modules_versions}"
  echo ""
  echo ""
  eval "${SKIP_SCRIPT}"
fi
dnf module reset ${module_arr} -y
dnf module enable ${module_version_arr} -y


# module_arr: remove the first spce
module_arr="${module_arr# }"
# module_arr: replace all spaces with |
module_arr="${module_arr// /|}"

echo ""
echo ""
echo ">>>>>>>>>>>>>>>>"
echo "Show enabled modules: (${module_version_arr} )"
echo "dnf module list ${module_version_arr} --enabled 2>&1 | grep -B 1 -E \"${module_arr}\""
echo ">>>>>>>>>>>>>>>>"

local check_module_status="$(dnf module list ${module_version_arr} --enabled 2>&1 | grep -B 1 -E "${module_arr}")"
if [[ -z "${check_module_status}" ]]; then
  echo "No modules enabled !..."
else
  echo "${check_module_status}"
fi

# inline replacement, Substring Replacement
# Ref. https://tldp.org/LDP/abs/html/string-manipulation.html
echo "--------------------------------------------------"
echo ""
echo ""

# -----------> do module reset / enable one time only End <---------------


# --- For RVM 1.29.8+ - Add system ruby as dependency for CentOS ---
# if ! $(dnf module list ruby:2.6 --enabled >/dev/null 2>/dev/null) ; then
#   dnf module reset ruby -y
#   dnf module enable ruby:2.6 -y
# fi
#
# # equals to dnf install ruby
# #dnf module install ruby:2.6/common -y
