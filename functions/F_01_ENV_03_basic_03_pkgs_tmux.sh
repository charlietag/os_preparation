# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "==============================="
echo "  Installing TMUX..."
echo "==============================="

#-----------------------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------------------
# For Tmux
yum install -y libevent libevent-devel ncurses ncurses-libs ncurses-base ncurses-devel

# For Tmux compile from git clone
yum install -y autoconf automake pkgconfig

# For tmux plugin copycat (for better UTF-8 character support)
yum install -y gawk

#-----------------------------------------------------------------------------------------
# Compile and install tmux
#-----------------------------------------------------------------------------------------
cd $TMP
git clone --depth 1 --branch "${tmux_tag_ver}" https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install


cd $TMP
SAFE_DELETE "tmux"
