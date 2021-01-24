render_cp_sed () {
  local cp_from=$1
  local cp_to=$2
  #local render_params="$(cat ${DATABAG_FILE} |grep -vE "^[[:space:]]*#" | grep -Eo "[[:space:]]*[^[:space:]]+=[\"']" | sed -r -e "s/[[:space:]=\"']*//g" | sort -n | uniq)"
  local render_params="$(cat ${cp_from} | grep -Eo '\{\{[-_[:alnum:]]+\}\}' | sed -r -e 's/\{|\}//g' | sort -n | uniq)"


  #----- Start to render template -----
  echo "Rendering file \"${cp_to}\" (using sed)"

  # cat ${cp_from} > ${cp_to}
  cat ${cp_from} | grep -Ev '^[[:space:]]*#' | sed '/^\s*$/d' > ${cp_to}

  for render_param in $render_params; do
    local render_param_value="$(
      echo "${!render_param}" | \
      sed -r \
          -e 's/\\/\\\\\\/g' \
          -e 's/\//\\\//g' \
          -e 's/\&/\\\&/g' \
      )"

    sed -r -e "s/\{\{${render_param}\}\}/${render_param_value}/g" -i ${cp_to}

  done
}

