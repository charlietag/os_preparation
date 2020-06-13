#!/bin/bash
FILE_SHOULD_BE_CHANGED="$(cat /usr/lib/systemd/system/nginx.service.d/php-fpm.conf | grep -v '^\s*#' | grep 'Wants=php-fpm.service')"
if [[ -n "${FILE_SHOULD_BE_CHANGED}" ]]; then
  sed -e 's/^#*/#/' -i /usr/lib/systemd/system/nginx.service.d/php-fpm.conf
  systemctl daemon-reload
fi
