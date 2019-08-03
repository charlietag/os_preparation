echo "==============================="
echo "  Installing basic dev packages for rails..."
echo "==============================="

#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
#For Rails (For installing rvm)
rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite

#For Passenger (Using puma instead)
#yum install -y curl-devel

#For compile latest ruby
yum install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel

#For RVM 1.29.8+ - Add system ruby as dependency for CentOS
yum install -y ruby

# ImageMagick6 - For rails 5.2+, active storage (gem 'mini_magick')
local image_magick_packages="$(curl -s https://imagemagick.org/download/linux/CentOS/x86_64/ |grep -Eo '"(ImageMagick-|ImageMagick-devel-|ImageMagick-libs-)+6.(\S)+(\.rpm)"' |xargs -i bash -c "echo https://imagemagick.org/download/linux/CentOS/x86_64/{}" | sed ':a;N;$!ba;s/\n/ /g')"
yum localinstall -y ${image_magick_packages}

# ----- Rails 6+ Preview use -----
# FFmpeg for video
rpm -Uvh https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum install -y ffmpeg ffmpeg-devel

# muPDF(need to purchase license) for PDFs (Popplerer is also supported)
yum install -y poppler poppler-devel

#  Generate PDF files tools - for gem: wicked_pdf (wrapper for wkhtmltopdf)
yum install -y wkhtmltopdf wkhtmltopdf-devel
