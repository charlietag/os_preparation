# start_puma () {
#   local chosen_puma_names="$(echo "${1}" | sed 's/,/\n/g')"
#   check_puma_service_exists "${chosen_puma_names}"
# }

# start_rails () {
#   check_if_is_root
#   for puma_service in ${PUMA_SERVICES}; do
#     systemctl start puma_service
#   done
# }
#
# stop_rails () {
#   check_if_is_root
#   for puma_service in ${PUMA_SERVICES}; do
#     systemctl stop puma_service
#   done
# }
#
# reload_rails () {
#   check_if_is_root
#   for puma_service in ${PUMA_SERVICES}; do
#     systemctl reload puma_service
#   done
# }
