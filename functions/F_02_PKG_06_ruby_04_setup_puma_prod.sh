# =====================
# Enable databag
# =====================
# RENDER_CP

local target_puma_folder="${rails_sites}/myrails/config/puma"

echo "========================================="
echo "Setup puma.rb for production"
echo "========================================="

su -l $current_user -c "test -d ${target_puma_folder} || mkdir -p ${target_puma_folder}"

# Add extra config into .gitignore file
if [[ ! -d ${target_puma_folder} ]]; then
  echo "FAILED: puma.rb for PROD !"
  exit
fi

echo "========================================="
echo "      Add puma.rb for PROD into myrails"
echo "========================================="
cat ${CONFIG_FOLDER}/user_home/rails_sites/myrails/config/puma/production.rb > ${target_puma_folder}/production.rb
chown ${current_user}.${current_user} ${target_puma_folder}/production.rb
