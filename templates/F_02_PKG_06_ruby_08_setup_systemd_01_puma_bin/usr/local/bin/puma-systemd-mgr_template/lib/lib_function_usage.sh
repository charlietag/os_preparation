usage () {
cat << EOF
Usage:
     ${THIS_SCRIPT_NAME} <Actions> <Services>

     ${THIS_SCRIPT_NAME} <Options>

Actions: works with Services [ -i | -a ]
    -s            # "start"   puma systemd service
    -p            # "stop"    puma systemd service
    -r            # "reload"  puma systemd service
    -e            # "enable"  puma systemd service
    -d            # "disable" puma systemd service
    -t            # "restart" puma systemd service

Services: Define puma name, works with Actions [ -s | -p | -r | -e | -d ]
    -i            # "choose"  puma service name
    -a            # "all"     puma services are chosen

Options:
    -h            # display this help
    -l            # list puma service name
    -g            # force to regenerate systemd configs of ALL puma services

Description:
    All functions here are based on Nginx configs:

      /etc/nginx/rails_sites/*.conf

    Names of puma services are the same as rails app name:

      RailsConsole > File.basename(Rails.root.to_s)

Examples:
    [ Start | Stop | Reload | Enable | Disable | Restart ] chosen puma service:

        ${THIS_SCRIPT_NAME} [ -s | -p | -r | -e | -d | -t ] -i <puma_service_name>
        ${THIS_SCRIPT_NAME} [ -s | -p | -r | -e | -d | -t ] -i <puma_service_name_1>,<puma_service_name_2>,...

    [ Start | Stop | Reload | Enable | Disable | Restart ] ALL puma services:

        ${THIS_SCRIPT_NAME} [ -s | -p | -r | -e | -d | -t ] -a

    List ALL puma services:

        ${THIS_SCRIPT_NAME} -l

    Force to regenerate systemd configs ALL puma services:

        ${THIS_SCRIPT_NAME} -g


EOF
}

show_help_and_exit () {
  echo ""
  echo "Maybe you could reference the correct usage:"
  echo "    ${THIS_SCRIPT_NAME} -h"
  echo ""
  exit
}

show_list_and_exit () {
  echo ""
  echo "List available names:"
  echo "    ${THIS_SCRIPT_NAME} -l"
  echo ""
  exit
}

show_gen_help_no_exit () {
  echo ""
  echo "Try to generate puma service unit files:"
  echo "    ${THIS_SCRIPT_NAME} -g"
  echo ""
  # exit
}
