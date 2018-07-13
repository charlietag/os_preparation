# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "      Install RVM"
echo "========================================="
su -l $current_user -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
su -l $current_user -c "\curl -sSL https://get.rvm.io | bash -s ${rvm_version}"
su -l $current_user -c "rvm install ${ruby_version}"
echo ""

echo "========================================="
echo "      gem update --system"
echo "========================================="
su -l $current_user -c "gem update --system"
echo ""

echo "========================================="
echo "      gem update"
echo "========================================="
su -l $current_user -c "yes | gem update"
echo ""

echo "========================================="
echo "      gem cleanup, delete old gems"
echo "========================================="
su -l $current_user -c "gem cleanup"
echo ""

echo "========================================="
echo "      gem install bundler"
echo "========================================="
su -l $current_user -c "gem install bundler"
echo ""

echo "========================================="
echo "(Rails:${rails_version}) gem install rails"
echo "========================================="
su -l $current_user -c "gem install rails -v \"~> ${rails_version}.0\""
echo ""

# rvm ctrl-c trap soltion workaround
echo "------------------------------------------"
echo "RVM trap workaround"
echo "modify rvm source code"
echo "------------------------------------------"
helper_copy_using_cat_user_home
echo ""

