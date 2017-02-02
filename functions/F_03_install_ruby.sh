local ruby_url="https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
local tgz_name="ruby-2.3.1.tar.gz"
local untgz_folder="ruby-2.3.1"

echo "========================================="
echo "      Download Ruby Source"
echo "========================================="
cd $TMP
wget $ruby_url
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
echo "      gem install bundler"
echo "========================================="
gem install bundler
echo "========================================="
echo "      gem install rails"
echo "========================================="
gem install rails

echo "========================================="
echo "      rm all files in tmp"
echo "========================================="
rm -fr $TMP/$tgz_name
rm -fr $TMP/$untgz_folder

