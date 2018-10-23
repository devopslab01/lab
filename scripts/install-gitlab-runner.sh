#!/bin/bash

#--- ENV -----------------------------------------------------------------------
SCRIPT_NAME="Install GitLab Runner (Ubuntu 18.04 LTS Bonic)"
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

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
apt -y install gitlab-runner

echo
echo "Run: gitlab-runner register"

#--- END -----------------------------------------------------------------------
echo; echo "Done."; echo
