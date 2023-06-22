#!/bin/bash

OUTPUT=""
UPDATE_LIST=""
LOG_FILE=/tmp/polybar-pacman.log
SLEEP_PID=0
N_UPDATES=0

trap 'exit' SIGINT
trap "check_for_updates" USR1
trap "notify" USR2

log() {
  #echo "[$(date -Is)]" "$@" >> $LOG_FILE
  :
}

main_loop() {
  echo '' > ${TMP_DIR}/status
  check_for_updates
  status
}

status_loop() {
  while true; do
    check_for_updates
    sleep 600 &
    SLEEP_PID=$!
    wait
  done
    
}

check_for_updates() {
  # enumerate update list
  log "Checking updates"
  echo "⌛"
  UPDATE_LIST=$(checkupdates | nl -w2 -s '. ')
  # count lines
  new_n_updates=$(echo -n "$UPDATE_LIST" | wc -l)
  [ "$new_n_updates" -gt "$N_UPDATES" ] && notify
  N_UPDATES="$new_n_updates"
  if [ ! $N_UPDATES -gt 0 ]; then
    OUTPUT="%{T-}0%{T-}"
  else
    OUTPUT="%{T2}%{F#e60053}$N_UPDATES"
  fi
  echo "$OUTPUT"
}

notify() {
  notification=$(echo "$UPDATE_LIST" | column -t -L -o " " | sed 's/->//g')
  notify-send -t 10 "Updates" "$notification"
}


  upgrade() {
    if [ -s ${TMP_DIR}repo.pkgs ]; then
      [ -s ${TMP_DIR}aur.pkgs ] && urxvt -tr  -sh 20 -fg white -bg black -e sh -c "aur sync -c -u --noview && sudo pacman -Syu --noconfirm" || \
                                urxvt -tr  -sh 20 -fg white -bg black -e sh -c "sudo pacman -Syu --noconfirm"
      echo "%{T7}0%{T-}" > ${TMP_DIR}status && >| ${TMP_DIR}repo.pkgs && >| ${TMP_DIR}aur.pkgs
    elif [ -s ${TMP_DIR}aur.pkgs ]; then
      urxvt -tr  -sh 20 -fg white -bg black -e sh -c "aur sync -c -u --noview && sudo pacman -Syu --noconfirm"
      echo "%{T7}0%{T-}" > ${TMP_DIR}status && >| ${TMP_DIR}repo.pkgs && >| ${TMP_DIR}aur.pkgs
    else
      notify-send "No updates"
    fi
  }

  flagged() {
    url="https://www.archlinux.org/packages/"
    options="sort=&arch=any&arch=x86_64&repo=Community&repo=Core&repo=Extra&repo=Multilib&q=&maintainer=&flagged=Flagged"
    page_number=2
    status=1
    flagged_packages=$(curl "$url?$options" 2> /dev/null | \
                       grep "/packages/extra/\|/packages/core/\|/packages/community/\|/packages/multilib/\|<td>20\|span class=\"flagged\"")
    local_packages=$(pacman -Q |  sed 's/\(.*\ \)\(.*$\)/\1/')

    while [ $status -eq 1 ]; do
      flagged_packages+=$'\n'"$(curl $url?page=$page_number\&$options 2> /dev/null | \
                                grep "/packages/extra/\|/packages/core/\|/packages/community/\|/packages/multilib/\|<td>20\|error-page\|span class=\"flagged\"")"
      echo $flagged_packages | grep "error-page" > /dev/null
      status=$?
      page_number="$((page_number+1))"
    done

    flagged_packages=$(echo "$flagged_packages" | sed 'N;N;N;s/\n/ /g;s/">/ /g' | awk '{print $7,$11,($12),($13) }' | \
                       sed 's/<\/span><\/td>//;s/<td>/(/g;;s/<\/td>/)/g' | column -t -o " ")
    notify-send -t 60000 "$(cat <(echo "Outdated Repo packages") \
                          <(awk 'FNR==NR{a[$1];next}($1 in a){print}' <(echo "$local_packages")  <(echo "$flagged_packages") | nl -s '.') \
                          <(echo) \
                          <(echo "Outdated AUR packages") \
                          <(aur search -qi $(aur repo -a | sed 's/:.*//') | grep "Out-of-date" | sed -e 's/aur\///' -e 's/(.*%)//' | nl -s '.'))"
  }

  [[ $# -eq 0 ]] && main_loop
  [[ $1 == "-s" ]] && status_loop
  [[ $1 == "-n" ]] && notify
  [[ $1 == "-c" ]] && clean
  [[ $1 == "--flagged" ]] && flagged

