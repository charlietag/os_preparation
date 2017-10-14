#--------------------------
#  Setup nginx sample configs
#--------------------------
# Default rpm installed: 
# /usr/share/vim/vimfiles/ftdetect/nginx.vim
# /usr/share/vim/vimfiles/indent/nginx.vim
# /usr/share/vim/vimfiles/syntax/nginx.vim

# Setup reference can be found at:
# https://arian.io/vim-syntax-highlighting-for-nginx/

#--------------------------
# The following setup the same for optnginx under $HOME/.vim/
echo "-----------"
echo "setup nginx vim syntax"
echo "-----------"
local nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local nginx_target=""
local nginx_target_folder=""
for nginx_conf in ${nginx_confs[@]}
do
  nginx_target="${nginx_conf/${CONFIG_FOLDER}/}"
  nginx_target_folder="$(dirname $nginx_target)"

  test -d $nginx_target_folder || mkdir -p $nginx_target_folder

  echo "Setting up config file \"${nginx_target}\"......"
  cat $nginx_conf > $nginx_target
done

