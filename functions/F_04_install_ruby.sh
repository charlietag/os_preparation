# =====================
# Enable databag
# =====================
# RENDER_CP

# config set
local tgz_name="$(basename $ruby_src_url)"
local untgz_folder="$(basename $ruby_src_url .tar.gz)"

# Start to install
echo "========================================="
echo "      Download Ruby Source"
echo "========================================="
cd $TMP
wget $ruby_src_url
tar -xzvf $tgz_name

echo "========================================="
echo "      Configure"
echo "========================================="
cd $TMP/$untgz_folder
./configure
echo "========================================="
echo "      make"
echo "========================================="
make
echo "========================================="
echo "      make install"
echo "========================================="
make install

echo "========================================="
echo "      gem update --system"
echo "========================================="
gem update --system
echo "========================================="
echo "      gem update"
echo "========================================="
yes | gem update

echo "========================================="
echo "      gem cleanup, delete old gems"
echo "========================================="
gem cleanup

echo "========================================="
echo "      gem install bundler"
echo "========================================="
gem install bundler
echo "========================================="
echo "(Rails:${rails_version}) gem install rails"
echo "========================================="
gem install rails -v "~> ${rails_version}.0"

echo "========================================="
echo "      rm all files in tmp"
echo "========================================="
rm -fr $TMP/$tgz_name
rm -fr $TMP/$untgz_folder

