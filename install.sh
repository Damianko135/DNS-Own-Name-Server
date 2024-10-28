#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
# Check if run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Detect distribution and set package installer
distribution=$(lsb_release -is)
case "$distribution" in
    Ubuntu) PACKAGE_INSTALLER="apt-get" ;;
    Debian) PACKAGE_INSTALLER="apt" ;;
    CentOS | RedHat) PACKAGE_INSTALLER="yum" ;;
    Fedora) PACKAGE_INSTALLER="dnf" ;;
    Alpine) PACKAGE_INSTALLER="apk" ;;
    openSUSE) PACKAGE_INSTALLER="zypper" ;;
    *) echo "Unsupported distribution for Docker installation"; exit 1  ;;
esac

set -e

# Prompt for technitium user password
echo "Enter password for technitium user:"
read -s technitium_password

# Add technitium user and set password
useradd -m --shell /bin/bash "technitium"
echo "technitium:$technitium_password" | chpasswd
usermod -aG sudo,docker technitium
# Seeing as this device will be used as the dns server, its fitting:
hostnamectl set-hostname "dns-1"

# Update and upgrade packages, then install Docker
$PACKAGE_INSTALLER update && $PACKAGE_INSTALLER upgrade -y
if ! curl -fsSL https://get.docker.com/ | sh; then
    echo "Failed to install Docker."
    exit 1
fi


