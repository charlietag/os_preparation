# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

local pkgs_list=""
echo "==============================="
echo "  Installing TMUX..."
echo "==============================="

#-----------------------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------------------
# For Tmux
#dnf install -y libevent libevent-devel ncurses ncurses-libs ncurses-base ncurses-devel
pkgs_list="${pkgs_list} libevent libevent-devel ncurses ncurses-libs ncurses-base ncurses-devel"

# For Tmux compile from git clone
#dnf install -y autoconf automake pkgconfig
pkgs_list="${pkgs_list} autoconf automake pkgconf-pkg-config"

# For tmux plugin copycat (for better UTF-8 character support)
#dnf install -y gawk
pkgs_list="${pkgs_list} gawk"

# Add this to avoid unknown dependencies
#dnf install -y tmux
pkgs_list="${pkgs_list} tmux"

# for compare float in shell script
pkgs_list="${pkgs_list} bc"

#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

#-----------------------------------------------------------------------------------------
# Compile and install tmux
#-----------------------------------------------------------------------------------------
local tmux_current_ver_float="$(tmux -V  | grep -Eo "[[:digit:]\.]+")"
local tmux_tag_ver_float="$(echo ${tmux_tag_ver} | grep -Eo "[[:digit:]\.]+")"
if [[ 1 -eq "$(echo "${tmux_current_ver_float} < ${tmux_tag_ver_float}" | bc)" ]]; then

  # ---------------------- Compile tmux if needed --------------------
  cd $TMP
  git clone --depth 1 --branch "${tmux_tag_ver}" https://github.com/tmux/tmux.git
  cd tmux

  sh autogen.sh
  ./configure && make
  make install

  cd $TMP
  SAFE_DELETE "tmux"
  # ---------------------- Compile tmux if needed --------------------

fi
