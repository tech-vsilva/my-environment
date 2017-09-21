#!/bin/bash

set -x

install_atom(){
  sudo add-apt-repository -y ppa:webupd8team/atom \
  && sudo apt-get update && sudo apt-get install -y atom
}

install_google_chrome(){
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
  && sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
  && sudo apt-get udpate \
  && sudo apt-get install google-chrome-stable
}

sudo apt-get update \
&& install_atom
&& install_google_chrome
