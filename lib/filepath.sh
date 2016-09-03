#-----------------------------------------------------------------------------------------
# Filepath Setup
#-----------------------------------------------------------------------------------------
CURRENT_FOLDER="$(dirname $(readlink -m $0))"

TEMPLATES="${CURRENT_FOLDER}/templates"
CONFIGS="${TEMPLATES}/environments"

FUNCTIONS="${CURRENT_FOLDER}/functions"


#-----------------------------------------------------------------------------------------
# Convert functions into function
#-----------------------------------------------------------------------------------------
FUNC_NAMES="$(ls $FUNCTIONS |grep -E '\.sh$'| sed 's/\.sh$//g')"

for FUNC_NAME in $FUNC_NAMES
do
  MAKE_FUNC="
  ${FUNC_NAME} (){
    . ${FUNCTIONS}/${FUNC_NAME}.sh
  }
  "
  eval "${MAKE_FUNC}"
done
