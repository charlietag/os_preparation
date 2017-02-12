#-----------------------------------------------------------------------------------------
#Self Customize /root/.all
#-----------------------------------------------------------------------------------------
local files=($(ls -a $CONFIG_FOLDER/home_setting | grep -E "^\.[A-Za-z0-9_]+$"))
for file in ${files[@]}
do
  rm -rf ${HOME}/$file
  cp -a $CONFIG_FOLDER/home_setting/$file ${HOME}/$file
done
RENDER_CP $CONFIG_FOLDER/home_setting/.gitconfig ${HOME}/.gitconfig
test -f /etc/screenrc && mv /etc/screenrc /etc/screenrc.bak

#-----------------------------------------------------------------------------------------
#Setup Vim Setting
#-----------------------------------------------------------------------------------------
mkdir -p ${HOME}/.vim/autoload ${HOME}/.vim/bundle && \
curl -LSso ${HOME}/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ${HOME}/.vim/bundle
git clone git://github.com/godlygeek/tabular.git
git clone https://github.com/Raimondi/delimitMate.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
#git clone https://github.com/vim-airline/vim-airline-themes

#Show git branch name
git clone git://github.com/tpope/vim-fugitive.git
#git clone git://github.com/airblade/vim-gitgutter.git

