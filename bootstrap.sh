#!/bin/bash

set -x

REPORT="${HOME}/bootstrap.txt"

rm -f "${REPORT}"

update(){
  sudo apt-get -q update
}

report(){
  echo "${1}" | tee -a "${REPORT}"
}

install(){
  report "installing ${1}"
  sudo apt-get -qqy install "${1}"
  if is_installed "${1}"; then
    report "${1} installed successfully!"
  fi
}

add_repo(){
  sudo add-apt-repository -y "${1}"
}

# verify if a package is installed
# return 0 if true, 1 if false
# Also informs about it in a report
is_installed() {
    dpkg -l "${1}" | grep -q ^ii \
    && report "${1} already installed, skipping." && return 0
    return 1
}

install_atom(){
  if ! is_installed atom; then
      add_repo 'ppa:webupd8team/atom' && update && install atom
  fi
}

install_google_chrome(){
  if ! is_installed google-chrome-stable; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list \
    && update && install google-chrome-stable
  fi
}

install_spotify(){
  if ! is_installed spotify-client; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 \
    && echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list \
    && update && install spotify-client
  fi
}

install_vlc(){
  if ! is_installed vlc; then
    add_repo 'ppa:videolan/stable-daily' && update && install vlc
  fi
}

install_java_8(){
  if ! is_installed oracle-java8-installer; then
    add_repo 'ppa:webupd8team/java' \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections \
    && update && install oracle-java8-installer
  fi
}

install_dev_packages(){
  sudo apt-get install -y arj \
  curl \
  wget \
  vim \
  git \
  build-essential \
  python-pip \
  python-dev \
  python-software-properties \
  && sudo pip install --upgrade pip
}

select_fastest_mirror(){
  sudo apt-get install -y aria2 git
  if ! [[ -f /usr/bin/apt-fast ]]; then
    git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast
    sudo cp /tmp/apt-fast/apt-fast /usr/bin
    sudo chmod +x /usr/bin/apt-fast
    sudo cp /tmp/apt-fast/apt-fast.conf /etc
    rm -rf /tmp/apt-fast
  fi
  local country="${1}"
  local mirrors = ""
  curl --remote-name "http://mirrors.ubuntu.com/${country}.txt"
  while read mirror; do
     mirrors+="${mirror}, "
  done < "${country}.txt"
  # remove last ', ' characters
  local mirrors_formatted=$(echo "$mirrors" |  sed 's/\(.*\), /\1/')
  echo "MIRRORS=('$mirrors_formatted')"
  rm -f "${country}.txt"
  # sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu\//http:\/\/ubuntu.uberglobalmirror.com\/archive\//' /etc/apt/sources.list
}

show_report(){
  cat "${REPORT}"
}

update
select_fastest_mirror 'DE'

# install_atom
# install_google_chrome
# install_spotify
# install_vlc
# install_java_8
# install_dev_packages

# show_report
