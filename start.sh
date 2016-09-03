#!/bin/bash
#*****************************************************************************
#* Choose "Minimal Server" during the intstallation (works With Minimal ISO)
#*****************************************************************************
. "$(dirname $(readlink -m $0))/lib/filepath.sh"

print_path

if [ -z "$PREDEFINED" ]
then
#environment
#install_mariadb
#install_php7
#install_ruby
#install_nginx
fi
