#!/bin/bash

echo
echo "--- Install GitLab (Ubuntu 18.04 LTS Bonic) ---"
echo

TARGET=$1

echo "TARGET:   $1"
echo

export DEBIAN_FRONTEND="noninteractive"

# Fix some "locale" issues
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

cd /opt/runlab/

apt install -y ca-certificates curl openssh-server postfix

GITLAB_DEB="script.deb.sh"
GITLAB_URL="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"
if [ ! -f "$GITLAB_DEB" ]; then wget ${GITLAB_URL}; fi
bash ./script.deb.sh

apt update
apt install gitlab-ce

sed -i -e "/external_url/s/^external_url.*/external_url 'http:\/\/gitlab.lab.local'/" /etc/gitlab/gitlab.rb

gitlab-ctl reconfigure

echo
echo "Got to http://gitlab.lab.local"

echo
echo "Done."
echo
