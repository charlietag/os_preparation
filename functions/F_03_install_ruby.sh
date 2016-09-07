local ruby_url="https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
local tgz_name="ruby-2.3.1.tar.gz"
local untgz_folder="ruby-2.3.1"

echo "========================================="
echo "      Download Ruby Source"
echo "========================================="
cd $TMP
wget $ruby_url
tar -xzvf $tgz_name

cd $TMP/$untgz_folder
echo "========================================="
echo "      Configure"
echo "========================================="
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
yes n | gem update
echo "========================================="
echo "      gem install bundler"
echo "========================================="
gem install bundler
echo "========================================="
echo "      gem install rails"
echo "========================================="
gem install rails


cd $TMP
echo "========================================="
echo "      rails new TestRails -d mysql"
echo "========================================="
rails new TestRails -d mysql #Create rails project, to verify
echo "========================================="
echo "      rm all files in tmp"
echo "========================================="
rm -fr $TMP/$tgz_name
rm -fr $TMP/$untgz_folder
rm -fr $TMP/TestRails

