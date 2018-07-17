# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "      Install RVM"
echo "========================================="
local rvm_install_retry=5


############### Install RVM retry Loop #############
let rvm_install_retry++
for ((i=1; i<=rvm_install_retry; i++)); do

  # ---------- Check RVM Installation -----------
  local rvm_check="$(su -l $current_user -c "which rvm 2>/dev/null")"
  if [[ -n "${rvm_check}" ]]; then
    echo "RVM is installed successfully!"
    break
  fi

  if [[ -z "${rvm_check}" ]]; then
    echo "RVM is not installed yet!"
    [[ $i -eq $rvm_install_retry ]] && exit
  fi

  echo -n "RVM installation (try: $i) "
  sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""

  # ---------- Remove gpg key and install gpg -----------
  su -l $current_user -c "rm -fr ${current_user_home}/.gnupg"
  su -l $current_user -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
  if [[ $? -ne 0 ]]; then
    echo "rvm gpg keyserver installation failed!"
    continue
  fi

  # ---------- Install RVM -----------
  su -l $current_user -c "\curl -sSL https://get.rvm.io | bash -s ${rvm_version}"
done
echo ""
############### Install RVM retry Loop #############



# ----- rvm ctrl-c trap soltion workaround ------
echo "------------------------------------------"
echo "RVM trap workaround"
echo "modify rvm source code"
echo "------------------------------------------"
task_copy_using_cat_user_home
echo ""

