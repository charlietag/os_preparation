#-----------------------------------------------------------------------------------------
# Filepath Setup
#-----------------------------------------------------------------------------------------
#***** lib use ******
CURRENT_FOLDER="$(dirname $(readlink -m $0))"
FUNCTIONS="${CURRENT_FOLDER}/functions"

#***** functions use ******
TEMPLATES="${CURRENT_FOLDER}/templates"
TMP="${CURRENT_FOLDER}/tmp"
# CONFIG_FOLDER ===> ${TEMPLATES}/{FUNC_NAME}
# Defined in lib/function.sh
