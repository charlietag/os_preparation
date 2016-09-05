#-----------------------------------------------------------------------------------------
# Usage
#-----------------------------------------------------------------------------------------
# -a -i , repo pure

#-----------------------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------------------
PRINT_HELP (){
  echo "usage: $(basename "${CURRENT_SCRIPT}")"
  echo "  -a                   ,  run all functions"
  echo "  -i func1 func2 func3 ,  run specified functions"
  echo "                          example: $(basename "${CURRENT_SCRIPT}") -i ${FUNC_NAMES[@]}"
  exit
}

L_IF_FUNC_EXISTS (){
  local L_ARGVS=()
  for FUNC_NAME in ${FUNC_NAMES[@]}
  do
    for ALL_ARGV in ${ALL_ARGVS[@]}
    do
      if [ "${FUNC_NAME}" == "${ALL_ARGV}" ]
      then
        L_ARGVS+=($FUNC_NAME)
      fi
    done
  done
  echo "${L_ARGVS[@]}"
}

L_RUN_SPECIFIED_FUNC (){
  local L_ARGVS_UNIQS=($@)
  if [ ! -z "${L_ARGVS_UNIQS}" ]
  then
    for L_ARGVS_UNIQ in ${L_ARGVS_UNIQS[@]}
    do
      #eval "${L_ARGVS_UNIQ}"
      echo ${L_ARGVS_UNIQ}
    done
  else
    echo "Function name \"${ALL_ARGVS[@]}\" not found. Please try again..."
    exit
  fi
}

#-----------------------------------------------------------------------------------------
# Actions
#-----------------------------------------------------------------------------------------
if [ "${FIRST_ARGV}" == "-a" ]
then
  #===========Select all funcs to run=======
  for FUNC_NAME in ${FUNC_NAMES[@]}
  do
    #eval "${FUNC_NAME}"
    echo "${FUNC_NAME}"
  done
  #===========Select all funcs to run=======

elif [ "${FIRST_ARGV}" == "-i" ]
then
  #===========Select specific funcs to run=======
  #**** Check if given argvs is in function lists ****
  L_ARGVS=($(L_IF_FUNC_EXISTS))

  #**** Distinct array ****
  L_ARGVS_UNIQS=($(echo "${L_ARGVS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
  #L_ARGVS_UNIQS=${L_ARGVS[@]}

  #**** Run funcs****
  L_RUN_SPECIFIED_FUNC ${L_ARGVS_UNIQS[@]}

  #===========Select specific funcs to run=======
else
  PRINT_HELP
fi