_task_check_variable_current_user
_task_check_variable_git_name_email

#-----------------------------------------------------------------------------------------
#Self Customize ${user_home}/.all
#-----------------------------------------------------------------------------------------

local current_user_home="$(getent passwd "$current_user" | cut -d':' -f6)"
local files=($(ls -a $HELPER_VIEW_FOLDER/user_home | grep -E "^\.[A-Za-z0-9_]+$"))

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
mkdir -p ${current_user_home}/.vim/autoload ${current_user_home}/.vim/bundle && \
curl -LSso ${current_user_home}/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ${current_user_home}/.vim/bundle
git clone https://github.com/godlygeek/tabular.git
git clone https://github.com/Raimondi/delimitMate.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
#git clone https://github.com/vim-airline/vim-airline-themes.git
git clone https://github.com/tpope/vim-sensible.git

# quickly move to position
git clone https://github.com/easymotion/vim-easymotion.git

# save vim session - avoid server crash
git clone https://github.com/tpope/vim-obsession.git
vim -u NONE -c "helptags vim-obsession/doc" -c q              # generate doc - vim-obsession help tag

#Show git branch name
git clone https://github.com/tpope/vim-fugitive.git
#git clone https://github.com/airblade/vim-gitgutter.git

#-----------------------------------------------------------------------------------------
#Make sure user_home priv is correct
#-----------------------------------------------------------------------------------------
chown -R ${current_user}.${current_user} ${current_user_home}
