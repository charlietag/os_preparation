local ruby_url="https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
local tgz_name="ruby-2.3.1.tar.gz"
local untgz_folder="ruby-2.3.1"

cd $TMP
wget $ruby_url
tar -xzvf $tgz_name

cd $TMP/$untgz_folder
./configure
make
make install

gem update --system
gem update
gem install bundler
gem install rails


cd $TMP
rails new TestRails -d mysql #Create rails project, to verify
rm -fr $TMP/$tgz_name
rm -fr $TMP/$untgz_folder
rm -fr $TMP/TestRails

