# Release

This document describes how to create an RPM repository containing all the 
software built from scratch and signed with PGP.

Currently it will build packages for the following platforms on those same
platforms:

* CentOS 7
* Fedora 30, 31

You'll be able to build everything from Fedora. So it is recommended to use
a clean Fedora machine to start the builds from.

# Preparation

We assume you have a fresh install of Fedora >= 30 with the following software 
installed:

    $ sudo dnf -y install fedora-packager rpm-sign nosync dnf-utils gnupg2 \
		yum qemu-user-static

## Mock

Make sure your current user account is a member of the `mock` group:

    $ sudo usermod -a -G mock $(id -un)

## Setup

Run `builder_setup.sh` with the user account you are going to 
build as.

	$ ./builder_setup.sh
	
This will create a GPG key and setup various configuration files. Check 
the file if you are curious, it is very simple!

# Building

	$ ./build_packages.sh

This will build all packages for all platforms specified at the top of 
the `build_packages.sh` file.

The repositories will be written to `${HOME}/repo/v2`.

You can use the scripts `copy_to_archive.sh` to create a `.tar.xz` archive
from the repository and `copy_to_web.sh` to copy it to your local web server,
ready to be configured, see below.

# Updating

If you re-run the `build_packages.sh` script, it will only build the packages
that changed since the last run.

# Configuration

Create the following snippet in `/etc/yum.repos.d/LC.repo` on the machine where 
you want to install Let's Connect!. Make sure the files can be found on the URLs 
mentioned below:

## CentOS

To install the PGP key:

	rpm --import https://vpn-builder.tuxed.net/repo/master/RPM-GPG-KEY-LC

Put this in `/etc/yum.repos.d/LC-master.repo`:

    [LC]
    name=Let's Connect! Packages (EL $releasever)
    baseurl=https://vpn-builder.tuxed.net/repo/v2/epel-$releasever-$basearch
    gpgcheck=1

## Fedora

To install the PGP key:

	rpm --import https://vpn-builder.tuxed.net/repo/master/RPM-GPG-KEY-LC

Put this in `/etc/yum.repos.d/LC-master.repo`:

    [LC]
    name=Let's Connect! Packages (Fedora $releasever) 
    baseurl=https://vpn-builder.tuxed.net/repo/v2/fedora-$releasever-$basearch
    gpgcheck=1
