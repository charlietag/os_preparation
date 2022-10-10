local pkgs_list=""
echo "==============================="
echo "  Installing basic dev packages for rails..."
echo "==============================="

#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
# --- For Rails (For installing rvm) ---
#rpm --quiet -q sqlite-devel || dnf -y install sqlite-devel   # use mysql not sqlite
pkgs_list="${pkgs_list} sqlite-devel"

# --- For Passenger (Using puma instead) ---
#dnf install -y curl-devel

# --- For compile latest ruby ---
#dnf install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel
pkgs_list="${pkgs_list} libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel ruby-devel"

# --- For RVM 1.29.8+ - Add system ruby as dependency for CentOS ---

# equals to dnf install ruby
#dnf module install ruby:2.7/common -y
# The following packages contain all pkgs in module install ruby:{version}/common

pkgs_list="${pkgs_list} ruby"

# --- For RVM 1.29.12 - Requirement glibc-headers obsolete on Fedora 33 ---

pkgs_list="${pkgs_list} glibc-headers"


# ----- Rails 6+ Preview use -----
# FFmpeg for video
if ! $(rpm --quiet -q rpmfusion-free-release) ; then
  rpm -Uvh https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
  #L_UPDATE_REPO 5000
fi
#dnf install -y ffmpeg ffmpeg-devel
pkgs_list="${pkgs_list} ffmpeg ffmpeg-devel"

# muPDF(need to purchase license) for PDFs (Popplerer is also supported)
#dnf install -y poppler poppler-devel
pkgs_list="${pkgs_list} poppler poppler-devel"

# Generate PDF files tools - for gem: wicked_pdf (wrapper for wkhtmltopdf)
#Not found in CentOS 8.1 / EPEL 8
# Instead, using gem "wkhtmltopdf_binary_gem"
#pkgs_list="${pkgs_list} wkhtmltopdf wkhtmltopdf-devel"

# ImageMagick latest version - 6.9+
pkgs_list="${pkgs_list} ImageMagick ImageMagick-libs ImageMagick-devel"

# ----- Rails 7+ Active Storage (gem 'ruby-vips') -----
# libvips for images variant
if ! $(rpm --quiet -q remi-release) ; then
  dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
  #L_UPDATE_REPO 5000
fi

pkgs_list="${pkgs_list} GeoIP GeoIP-devel"

# libvips
# dnf install -y vips vips-tools
pkgs_list="${pkgs_list} vips vips-tools"

# redis
pkgs_list="${pkgs_list} redis redis-devel"


#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

# -- ImageMagick6 - For rails 5.2+, active storage (gem 'mini_magick') --
# CentOS 7: ImageMagick 6.7.x
# CentOS 8: ImageMagick 6.9.x
# gem - Rmagick requires ImageMagick 6.7.7+
# gem - mini_magick requires ImageMagick 6.8.8-3+
# ImageMagick latest version - 6.9+
#local image_magick_packages="$(curl -s https://imagemagick.org/download/linux/CentOS/x86_64/ |grep -Eo '"(ImageMagick-|ImageMagick-devel-|ImageMagick-libs-)+6.(\S)+(\.rpm)"' |xargs -i bash -c "echo https://imagemagick.org/download/linux/CentOS/x86_64/{}" | sed ':a;N;$!ba;s/\n/ /g')"
#dnf localinstall -y ${image_magick_packages}

