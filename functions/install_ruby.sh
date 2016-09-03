TGZ_URL="https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
TGZ_NAME="ruby-2.3.1.tar.gz"
UTGZ_FOLDER="ruby-2.3.1"

cd $TMP
wget $RUBY_TGZ
tar -xzvf $TGZ_NAME

cd $TMP/$UTGZ_FOLDER
./configure
make
make install

gem update --system
gem update
gem install bundler
gem install rails


cd $TMP
rails new TestRails -d mysql #Create rails project, to verify
rm -fr $TMP/$TGZ_NAME
rm -fr $TMP/$UTGZ_FOLDER
rm -fr $TMP/TestRails

