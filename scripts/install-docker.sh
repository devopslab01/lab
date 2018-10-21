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

apt update
apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt-cache policy docker-ce
apt -y install docker-ce
systemctl status docker

curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version

curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

base=https://github.com/docker/machine/releases/download/v0.14.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  install /tmp/docker-machine /usr/local/bin/docker-machine

docker-machine version

base=https://raw.githubusercontent.com/docker/machine/v0.14.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done


#--- END -----------------------------------------------------------------------
echo; echo "Done."; echo
