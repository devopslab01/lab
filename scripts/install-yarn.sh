#!/bin/bash

#--- ENV -----------------------------------------------------------------------
SCRIPT_NAME="Install Yarn (Ubuntu 18.04 LTS Bonic)"
TARGET=$1
export DEBIAN_FRONTEND="noninteractive"
export LC_ALL="en_US.UTF-8"

#--- HEAD ----------------------------------------------------------------------
echo; echo "--- $SCRIPT_NAME ---"; echo; echo "TARGET: $1"; echo

# Fix some "locale" issues
if ! grep -q "LC_ALL" /etc/default/locale; then
  echo "Setting LC_ALL to en_US.UTF-8 ..."
  echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
else
  echo "LC_ALL is already set."
fi

cd /opt/runlab/

#--- ACTION --------------------------------------------------------------------

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt update
apt install -y yarn

yarn --version

#--- END -----------------------------------------------------------------------
echo; echo "Done."; echo
