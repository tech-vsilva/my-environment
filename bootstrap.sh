#!/bin/bash

set -x

# https://askubuntu.com/a/98467
try_install() {
    dpkg -l "${1}" | grep -q ^ii && return 1
    sudo apt-get -y install "$@"
    return 0
}

install_atom(){
  if try_install atom; then
      sudo add-apt-repository -y ppa:webupd8team/atom \
      && sudo apt-get update && sudo apt-get install -y atom
  fi
}

install_google_chrome(){
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
  && sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
  && sudo apt-get udpate \
  && sudo apt-get install google-chrome-stable
}

sudo apt-get update \
&& install_atom \
&& install_google_chrome
