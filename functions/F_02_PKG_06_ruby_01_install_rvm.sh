# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "      Install RVM"
echo "========================================="
su -l $current_user -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
if [[ $? -ne 0 ]]; then
  echo "rvm gpg keyserver installation failed!"
  exit
fi

su -l $current_user -c "\curl -sSL https://get.rvm.io | bash -s ${rvm_version}"
echo ""

local rvm_check="$(su -l $current_user -c "which rvm 2>/dev/null")"
if [[ -z "${rvm_check}" ]]; then
  echo "rvm installation failed!"
  exit
fi

# rvm ctrl-c trap soltion workaround
echo "------------------------------------------"
echo "RVM trap workaround"
echo "modify rvm source code"
echo "------------------------------------------"
task_copy_using_cat_user_home
echo ""
