#-----------------------------------------------------------------------------------------
# Usage
#-----------------------------------------------------------------------------------------
# -a -i , repo pure

#-----------------------------------------------------------------------------------------
# Actions
#-----------------------------------------------------------------------------------------
if [ ! -z "${GIVEN_ARGVS}" ]
then
  #**** Check if given argvs is in function lists ****
  L_ARGVS=()
  for FUNC_NAME in $FUNC_NAMES
  do
    for GIVEN_ARGV in $GIVEN_ARGVS
    do
      if [ "${FUNC_NAME}" == "${GIVEN_ARGV}" ]
      then
        L_ARGVS+=($FUNC_NAME)
      fi
    done
  done

  L_ARGVS_UNIQS=($(echo "${L_ARGVS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
  #L_ARGVS_UNIQS=${L_ARGVS[@]}
  if [ ! -z "${L_ARGVS_UNIQS}" ]
  then
    for L_ARGVS_UNIQ in ${L_ARGVS_UNIQS[@]}
    do
      #echo ${L_ARGVS_UNIQ}
      eval "${L_ARGVS_UNIQ}"
    done
  else
    echo "Given argv is wrong!"
    echo "Please try again!"
    exit
  fi
  #**** Check if given argvs is in function lists ****
else
  for FUNC_NAME in $FUNC_NAMES
  do
    eval "${FUNC_NAME}"
  done
fi
