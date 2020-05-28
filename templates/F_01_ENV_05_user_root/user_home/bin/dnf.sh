############### Fetch dnf repo retry Loop (For epel-modular) #############
dnf_makecache() {
		dnf clean all

    local dnf_repo_install_retry=5000

    for ((i=1; ; i++)); do

      # ---------- Try to update repo metadata cache -----------
      #local dnf_repo_check="$(dnf makecache >/dev/null 2>/dev/null && echo "Success")"
      dnf makecache
      echo ""
      echo ""
      echo ""
      local dnf_repo_check="$([[ $? -eq 0 ]] && echo "Success")"
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
  local repo_expired_days=2
  local repo_check_days_ago="$(dnf repolist 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"


  if [[ $repo_check_days_ago -gt $repo_expired_days ]]; then
		echo "---------------------------------------"
    echo "Last metadata expiration check: ${repo_check_days_ago} days ago!"
    echo "CMD:"
    echo "  dnf clean all ; dnf makecache"
		echo "---------------------------------------"
		echo ""
    dnf_makecache
    repo_check_days_ago="$(dnf repolist 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
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
    repo_check_days_ago="$(dnf repolist 2>&1 | grep "Last metadata expiration check" | awk -F' on ' '{print $2}' | xargs -i bash -c "date -d '{}' +'%s'" | xargs -i bash -c 'echo "scale=0; ($(date +%s) - {})/86400"' |bc)"
		echo ""
		echo ""
		echo ""
  fi


  local dnf_argv="$@"
  echo "---------------------------------------"
  echo "CMD: (Last time check repo: ${repo_check_days_ago} days ago)"
  echo "  dnf ${dnf_argv[@]}"
  echo "---------------------------------------"
	echo ""
  dnf ${dnf_argv[@]}
	echo ""
	echo ""
	echo ""
}

main $@
