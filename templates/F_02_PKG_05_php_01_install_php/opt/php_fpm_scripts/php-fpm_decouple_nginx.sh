#!/bin/bash
sed -e 's/^#*/#/' -i /usr/lib/systemd/system/nginx.service.d/php-fpm.conf
