#-----------------------------------------------------------------------------------------
# Filepath Setup
#-----------------------------------------------------------------------------------------
CURRENT_FOLDER="$(dirname $(readlink -m $0))"

TEMPLATES="${CURRENT_FOLDER}/templates"
FUNCTIONS="${CURRENT_FOLDER}/functions"


#-----------------------------------------------------------------------------------------
# Convert functions into function
#-----------------------------------------------------------------------------------------
FUNC_NAMES="$(ls $FUNCTIONS |grep -E '\.sh$'| sed 's/\.sh$//g')"

for FUNC_NAME in $FUNC_NAMES
do
  CONFIG_FOLDER="${TEMPLATES}/${FUNC_NAME}"
  MAKE_FUNC="
  ${FUNC_NAME} (){
    echo \"==============================\"
    echo \"        ${FUNC_NAME}\"
    echo \"==============================\"

    CONFIG_FOLDER=\"${CONFIG_FOLDER}\"
    if [ ! -d ${CONFIG_FOLDER} ]
    then
      mkdir -p ${CONFIG_FOLDER}
      touch ${CONFIG_FOLDER}/.keep
    fi
    . ${FUNCTIONS}/${FUNC_NAME}.sh
  }
  "
  eval "${MAKE_FUNC}"
  #echo "${MAKE_FUNC}" #debug use
done
