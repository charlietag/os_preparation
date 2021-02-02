############### Fetch dnf repo retry Loop (For epel-modular) #############
dnf_makecache() {
    dnf clean all

    local dnf_repo_install_retry=5000

    for ((i=1; ; i++)); do

      # ---------- Try to update repo metadata cache -----------
      #local dnf_repo_check="$(dnf makecache >/dev/null 2>/dev/null && echo "Success")"
      dnf makecache
      local dnf_repo_check="$([[ $? -eq 0 ]] && echo "Success")"
      echo ""
      echo ""
      echo ""

      if [[ -n "${dnf_repo_check}" ]]; then
        echo "dnf metadata is updated successfully...!"
        break
      fi

      if [[ -z "${dnf_repo_check}" ]]; then
        echo "dnf metadata is not updated yet!"
        [[ $i -gt $dnf_repo_install_retry ]] && exit
      fi

      echo -n "dnf metadata updating (try: $i) "
      #sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""
      sleep 1; echo -n "."; echo ""
    done
}
############### Fetch dnf repo retry Loop (For epel-modular) #############

main() {
  #echo "Checking dnf metadata cache... (might take awhile)"
  local repo_expired_days=2
  local repo_cache_file_count="$(find /var/cache/dnf -name repomd.xml | wc -l)"
  #local repo_cache_enabled_count="$(dnf repolist | grep -EA 200 'repo[[:space:]]+id[[:space:]]+repo[[:space:]]+name' | grep -vE 'repo[[:space:]]+id[[:space:]]+repo[[:space:]]+name|repolist:[[:space:]]+[[:print:]]*' | wc -l)"
  local repo_cache_enabled_count="$(echo "$(cat /etc/yum.repos.d/* |grep -E '^\s*\[[[:print:]]*\]' | sed 's/[][]//g' | wc -l)-$(cat /etc/yum.repos.d/* | grep 'enabled=0' | wc -l)" | bc)"
  local repo_check_days_ago

  if [[ $repo_cache_file_count -ne $repo_cache_enabled_count ]]; then
    echo "---------------------------------------"
    echo "DNF CACHE DATA IS NOT CLEAN... !"
    echo "CMD:"
    echo "  dnf clean all ; dnf makecache"
    echo "---------------------------------------"
    echo ""
    dnf_makecache
    echo ""
    echo ""
    echo ""
  else

    #repo_check_days_ago="$(dnf updateinfo 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
    repo_check_days_ago="$(stat -c "%Z" /var/cache/dnf/packages.db | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
    if [[ $repo_check_days_ago -gt $repo_expired_days ]]; then
      echo "---------------------------------------"
      echo "Last metadata expiration check: ${repo_check_days_ago} days ago!"
      echo "CMD:"
      echo "  dnf clean all ; dnf makecache"
      echo "---------------------------------------"
      echo ""
      dnf_makecache
      #repo_check_days_ago="$(dnf updateinfo 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
      repo_check_days_ago="$(stat -c "%Z" /var/cache/dnf/packages.db | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
      echo ""
      echo ""
      echo ""
    fi

    if [[ $repo_check_days_ago -lt 0 ]]; then
      echo ""
      echo "Current date time < metadata cache time..."
      echo "Please make sure your date time is currect...!"
      echo ""
      echo "---------------------------------------"
      echo "Last metadata expiration check: ${repo_check_days_ago} days ago!"
      echo "CMD:"
      echo "  dnf clean all ; dnf makecache"
      echo "---------------------------------------"
      echo ""
      dnf_makecache
      #repo_check_days_ago="$(dnf updateinfo 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
      repo_check_days_ago="$(stat -c "%Z" /var/cache/dnf/packages.db | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
      echo ""
      echo ""
      echo ""
    fi

  fi

  # ---------------------------------------
  # passing complex argv
  # ---------------------------------------
  # Ref. https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
  #
  # --- wrong ---
  # cannot assign to another var
  # local dnf_argv="$@"
  # local dnf_argv="${@}"
  # dnf "$@"
  # dnf $@
  # dnf $[@]

  # --- correct ---
  # dnf "${@}"
  # dnf.sh group install "Minimal Install" "Server"
  # ===>
  #   ++ dnf group install 'Minimal Install' Server

  # ---------------------------------------

  echo "---------------------------------------"
  [[ -n "${repo_check_days_ago}" ]] && echo "CMD: (Last time check repo: ${repo_check_days_ago} days ago)"
  # echo "  dnf ${@}"
  echo "---------------------------------------"
  echo ""
  set -x
  dnf "${@}"
  set +x
  echo ""
  echo ""
  echo ""
}

main "${@}"
