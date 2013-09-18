#!/bin/bash

function countdown() {
  local i 
  printf %s "$1"
  sleep 1
  for ((i=$1-1; i>=1; i--)); do
    printf '\b%d' "$i"
    sleep 1
  done
}

showmenu="no"
if [ -f /root/.showfuelmenu ]; then
  . /root/.showfuelmenu
fi
if [[ "$showmenu" == "yes" || "$showmenu" == "YES" ]]; then
  fuelmenu
  #Reread /etc/sysconfig/network to inform puppet of changes
  . /etc/sysconfig/network
else
  #Give user 5 seconds to enter fuelmenu or else continue
  echo
  echo -n "Press any key to enter Fuel Setup... "
  countdown 5 & pid=$!
  if ! read -s -n 1 -t 5; then
    echo
    echo "Skipping Fuel Setup..."
  else
    kill "$pid"
    echo "Entering Fuel Setup..."
    fuelmenu
  fi
fi

puppet apply  /etc/puppet/modules/nailgun/examples/site.pp
