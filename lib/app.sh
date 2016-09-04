#------------------------------------
# Define lib path
#------------------------------------
LIB="$(dirname $(readlink -m $0))/lib"

#------------------------------------
# Include libaries
#------------------------------------
. $LIB/filepath.sh
. $LIB/function.sh
. $LIB/help.sh
