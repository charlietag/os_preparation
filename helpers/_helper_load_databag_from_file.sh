local src_file="${DATABAG}/$1"

if [[ ! -s "${src_file}" ]]; then
  echo "FAILED: Databag file \"${src_file}\" not exists!"
  exit
fi
. ${src_file}
