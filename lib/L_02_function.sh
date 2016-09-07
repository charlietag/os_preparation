#-----------------------------------------------------------------------------------------
# Convert functions into function
#-----------------------------------------------------------------------------------------
for FUNC_NAME in ${FUNC_NAMES[@]}
do
  CONFIG_FOLDER="${TEMPLATES}/${FUNC_NAME}"
  DATABAG_FILE="${DATABAG}/${FUNC_NAME}.cfg"
  L_IF_RENDER_USE="$(grep "RENDER_CP" "${FUNCTIONS}/${FUNC_NAME}.sh")"
  MAKE_FUNC="
  ${FUNC_NAME} (){
    echo \"==============================\"
    echo \"        ${FUNC_NAME}\"
    echo \"==============================\"

    CONFIG_FOLDER=\"${CONFIG_FOLDER}\"
    #if [ ! -d ${CONFIG_FOLDER} ]
    #then
    #  mkdir -p ${CONFIG_FOLDER}
    #  touch ${CONFIG_FOLDER}/.keep
    #fi
    if [ ! -z \"${L_IF_RENDER_USE}\" ]
    then
      if [ -f \"${DATABAG_FILE}\" ]
      then
        echo -n \"Reading data file: ${DATABAG_FILE}.\"
        slee 1
        echo -n \".\"
        slee 1
        echo -n \".\"
        slee 1
        echo -n \".\"
        slee 1
        echo \".\"
        . ${DATABAG_FILE}
      else
        echo \"Data file for databag not found:\"
        echo \"${DATABAG_FILE}\"
        exit
      fi
    fi
    . ${FUNCTIONS}/${FUNC_NAME}.sh
    cd $CURRENT_FOLDER
  }
  "
  eval "${MAKE_FUNC}"
  #echo "${MAKE_FUNC}" #debug use
done

