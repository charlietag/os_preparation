# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#--------------------------
#  Setup nginx sample configs
#--------------------------
task_copy_using_render


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
# The following setup the same for nginx under $HOME/.vim/
#--------------------------
# already setup in helper_env_user_base
