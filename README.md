# Release

This document describes how to create RPM repositories containing all software 
built from scratch and signed with PGP.

The repository will be read to be served from a web server and can be used by
servers to install the software.

The builder will run on Fedora >= 30 and will build software for all supported
RPM-based distributions:

* CentOS 7 (Red Hat Enterprise Linux 7)
* Fedora 30
* Fedora 31

It is recommended you create a VM specifically for creating the repositories.

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

The repositories will be written to `${HOME}/repo/master`.

You can use the scripts `copy_to_archive.sh` to create a `.tar.xz` archive
from the repository and `copy_to_web.sh` to copy it to a local web server
running no the same machine.

# Updating

If you re-run the `build_packages.sh` script, it will build the packages
that changed since the last run.

# Configuration

Depending on the OS you want to install the software from the generated  
repository on, perform the steps shown below steps.

Make sure you replace the URL below, i.e. `vpn-builder.tuxed.net` with your 
build host!

## CentOS

To install the PGP key:

	$ sudo rpm --import https://vpn-builder.tuxed.net/repo/master/RPM-GPG-KEY-LC

Put this in `/etc/yum.repos.d/LC-master.repo`:

    [LC-master]
    name=Let's Connect! Packages (EL $releasever)
    baseurl=https://vpn-builder.tuxed.net/repo/master/epel-$releasever-$basearch
    gpgcheck=1

## Fedora

To install the PGP key:

	$ sudo rpm --import https://vpn-builder.tuxed.net/repo/master/RPM-GPG-KEY-LC

Put this in `/etc/yum.repos.d/LC-master.repo`:

    [LC-master]
    name=Let's Connect! Packages (Fedora $releasever) 
    baseurl=https://vpn-builder.tuxed.net/repo/master/fedora-$releasever-$basearch
    gpgcheck=1
