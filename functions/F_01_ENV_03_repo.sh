# =====================
# Enable databag
# =====================
# RENDER_CP
# config set

#-----------------------------------------------------------------------------------------
# YUM Repo
#-----------------------------------------------------------------------------------------
local centos_repo="/etc/yum.repos.d/"
local repo_fail=0
local repos=(webtatic MariaDB node)

# =============================
# check repo exists function
# =============================
check_repo_exist (){
  for repo in ${repos[@]}
  do
    if [ -z "$(ls $centos_repo |grep -E "${repo}")" ]
    then
      echo "failed to find repo \"${repo}\""
      repo_fail=1
    fi
  done
}

# =============================
#Make sure repo exists before running
# =============================
repo_fail=0
check_repo_exist

# =============================
# Install repo if not exists
# =============================
if [ $repo_fail -eq 1 ]
then
  #PHP
  rpm -Uvh $epel_yum_repo
  rpm -Uvh $php_yum_repo

  #NodeJS
  curl --silent --location "${node_yum_repo}" | bash -

  #MariaDB
  echo "-----------"
  echo "setup mariadb configs include.d"
  echo "-----------"
  local mariadb_confs=($(find ${CONFIG_FOLDER} -type f))
  local mariadb_target=""
  local mariadb_target_folder=""
  for mariadb_conf in ${mariadb_confs[@]}
  do
    mariadb_target="${mariadb_conf/${CONFIG_FOLDER}/}"
    mariadb_target_folder="$(dirname $mariadb_target)"

    test -d $mariadb_target_folder || mkdir -p $mariadb_target_folder

    # use RENDER_CP to fetch var from datadog
    RENDER_CP $mariadb_conf $mariadb_target
  done

fi

# =============================
#Make sure repo exists before running
# =============================
repo_fail=0
check_repo_exist
if [ $repo_fail -eq 1 ]
then
  echo "Some repo is not installed properly!"
  exit
fi

# =============================
# Clean yum repo
# =============================
yum clean all

