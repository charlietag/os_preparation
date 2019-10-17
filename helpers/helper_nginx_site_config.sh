# ------------------------------------
# Make sure apply action is currect.
[[ -z "${site_type}" ]] && eval "${SKIP_SCRIPT}"
[[ "${site_type}" = "disable" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


#--------------------------------------
# Rendering nginx site config
#--------------------------------------
echo "========================================="
echo "  Rendering nginx configuration --- ${site_type} SITE"
echo "========================================="

# ---------- Define var ---------
#if [[ -z "${site_type}" ]]; then
#  echo "\"site_type\" is not defined !"
#  exit
#fi

if [[ "${site_type}" = "laravel" ]]; then
  local sample_config="${HELPER_VIEW_FOLDER}/etc/nginx/laravel_sites/sample-php.conf"
fi

if [[ "${site_type}" = "rails" ]]; then
  local sample_config="${HELPER_VIEW_FOLDER}/etc/nginx/rails_sites/sample-rails.conf"
fi


# ---------- Start to render config ---------
local nginx_target_folder="$(dirname "${sample_config/${HELPER_VIEW_FOLDER}/}")"

test -d $nginx_target_folder || mkdir -p $nginx_target_folder

local render_target_file="${nginx_target_folder}/${server_name}.conf"

RENDER_CP_SED $sample_config $render_target_file

