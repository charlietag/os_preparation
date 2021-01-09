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
local module
# (stream)
local version

for module_version in ${dnf_enabled_modules_versions[@]}; do

  # Actually, if nginx 1.14 is installed, then dnf will not allow you to install other version nginx, or  do a nginx module reset
  if ! $(dnf module list ${module_version} --enabled >/dev/null 2>/dev/null) ; then

    echo "==================================================="
    echo "@AppStream"
    echo "Enabling module : ${module_version}"
    echo "==================================================="

    # ----------------
    # used variable defined
    # ----------------
    # ex: nginx
    module="$(echo ${module_version} | cut -d':' -f1)"
    # ex: 1.18
    version="$(echo ${module_version} | cut -d':' -f2)"
    # ex: nginx:1.18
    # ${module_version}
    # echo "${module_version}"
    # ----------------
    dnf module reset ${module} -y
    dnf module enable ${module_version} -y
  fi

done

# --- For RVM 1.29.8+ - Add system ruby as dependency for CentOS ---
# if ! $(dnf module list ruby:2.6 --enabled >/dev/null 2>/dev/null) ; then
#   dnf module reset ruby -y
#   dnf module enable ruby:2.6 -y
# fi
#
# # equals to dnf install ruby
# #dnf module install ruby:2.6/common -y
