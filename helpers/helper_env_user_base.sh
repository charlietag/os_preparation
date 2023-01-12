_task_check_variable_current_user
_task_check_variable_git_name_email

#-----------------------------------------------------------------------------------------
#Self Customize ${user_home}/.all
#-----------------------------------------------------------------------------------------

local current_user_home="$(getent passwd "$current_user" | cut -d':' -f6)"
local files=($(ls -a $HELPER_VIEW_FOLDER/user_home | grep -E "^\.[A-Za-z0-9_]+[.]*[A-Za-z0-9_]*$"))

sed -i '/bash_base\//d' $current_user_home/.bashrc
echo 'source $HOME/.bash_base/.base.sh' >> $current_user_home/.bashrc

for file in ${files[@]}
do
  rm -rf ${current_user_home}/$file
  \cp -a $HELPER_VIEW_FOLDER/user_home/$file ${current_user_home}/$file
done
RENDER_CP $HELPER_VIEW_FOLDER/user_home/.gitconfig ${current_user_home}/.gitconfig
test -f /etc/screenrc && mv /etc/screenrc /etc/screenrc.bak

#-----------------------------------------------------------------------------------------
#Setup Vim Setting
#-----------------------------------------------------------------------------------------
# [[ -d ${current_user_home}/.vim/bundle ]] && SAFE_DELETE "${current_user_home}/.vim/bundle"
# mkdir -p ${current_user_home}/.vim/autoload ${current_user_home}/.vim/bundle && \
# curl -LSso ${current_user_home}/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim


# cd ${current_user_home}/.vim/bundle

# ---- Start Fetching vim plugins from github ----

  #vim-airline/vim-airline-themes
# quickly move to position ---> easymotion/vim-easymotion
# Show git branch name     ---> tpope/vim-fugitive
# local git_fetch_concurrency=10
# local vim_git_repos=(
#   "godlygeek/tabular"
#   "Raimondi/delimitMate"
#   "scrooloose/nerdtree"
#   "vim-airline/vim-airline"
#   "tpope/vim-sensible"
#   "easymotion/vim-easymotion"
#   "tpope/vim-obsession"
#   "tpope/vim-fugitive"
#   "airblade/vim-gitgutter"
#   "mattn/emmet-vim"
#   "tomtom/tcomment_vim"
#   "tpope/vim-surround"
#   "tpope/vim-endwise"
#   "vim-ruby/vim-ruby"
#   "ap/vim-css-color"
#   "charlietag/nginx.vim"
#   "charlietag/lucid_tag.vim"
# )

# echo "${vim_git_repos[@]}" | tr ' ' '\n' | \
#   xargs -P ${git_fetch_concurrency} -I{} bash -c \
#   "echo ----- Downloading Vim Plugin : {} -----; git clone https://github.com/{}.git; echo "



# save vim session - avoid server crash ---> tpope/vim-obsession
# vim -u NONE -c "helptags vim-obsession/doc" -c q              # generate doc - vim-obsession help tag

# Move plugin management out to another repo and replace vim manager with vim-plug
su -l ${current_user} -c 'bash <(curl -LSs https://raw.githubusercontent.com/charlietag/vim_settings/master/utils/install.sh)'

# ---- Start Fetching vim plugins from github END----

#-----------------------------------------------------------------------------------------
#Setup Tmux Plugin
#-----------------------------------------------------------------------------------------
# [[ -d ${current_user_home}/.tmux/plugins ]] && SAFE_DELETE "${current_user_home}/.tmux/plugins"
# mkdir -p ${current_user_home}/.tmux/plugins

# cd ${current_user_home}/.tmux/plugins

# ---- Start Fetching tmux plugins from github ----
# local git_fetch_concurrency=10
# cat $HELPER_VIEW_FOLDER/user_home/.tmux.conf |grep '@plugin' |grep -Ev "^#" | awk -F"'" '{print $2}' | \
#   xargs -P ${git_fetch_concurrency} -I{} bash -c \
#   "echo ----- Downloading Tmux Plugin : {} -----; git clone https://github.com/{}.git; echo "
# ---- Start Fetching tmux plugins from github END----

# Move plugin management out to another repo
su -l ${current_user} -c 'bash <(curl -LSs https://raw.githubusercontent.com/charlietag/tmux_settings/master/utils/install.sh)'


#-----------------------------------------------------------------------------------------
#Make sure user_home priv is correct
#-----------------------------------------------------------------------------------------
echo "===== chown -R ${current_user}.${current_user} ${current_user_home} (could take awhile...)====="
chown -R ${current_user}.${current_user} ${current_user_home}
