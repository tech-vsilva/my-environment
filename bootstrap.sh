#!/bin/bash

set -x

update(){
  sudo apt-get update
}

install(){
  sudo apt-get -qqy install "${1}"
}

# https://askubuntu.com/a/98467
is_installed() {
    dpkg -l "${1}" | grep -q ^ii && return 0
    return 1
}

install_atom(){
  if ! is_installed atom; then
      sudo add-apt-repository -y ppa:webupd8team/atom \
      && update && install atom
  fi
}

install_google_chrome(){
  if ! is_installed google-chrome-stable; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && update && install google-chrome-stable
  fi
}

update
install_atom
install_google_chrome
