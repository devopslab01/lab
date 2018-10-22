#!/bin/bash

#--- ENV -----------------------------------------------------------------------
SCRIPT_NAME="Install GitLab (Ubuntu 18.04 LTS Bonic)"
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

apt install -y ca-certificates curl openssh-server postfix

GITLAB_DEB="script.deb.sh"
GITLAB_URL="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"
if [ ! -f "$GITLAB_DEB" ]; then wget ${GITLAB_URL}; fi
bash ./script.deb.sh

apt update
apt install gitlab-ce

sed -i -e "/external_url/s/^external_url.*/external_url 'https:\/\/gitlab.lab.local'/" /etc/gitlab/gitlab.rb

gitlab-ctl reconfigure

echo
echo "Got to https://gitlab.lab.local"

echo
echo "Done."
echo
