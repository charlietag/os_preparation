#-----------------------------------------------------------------------------------------
# Filepath Setup
#-----------------------------------------------------------------------------------------
CURRENT_FOLDER="$(dirname $(readlink -m $0))"

TEMPLATES="${CURRENT_FOLDER}/templates"
FUNCTIONS="${CURRENT_FOLDER}/functions"
TMP="${CURRENT_FOLDER}/tmp"
