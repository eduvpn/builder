#!/bin/sh
KEY_IDENTITY=release@example.org
PACKAGE_BRANCH=master
REPO_ROOT=${HOME}/repo/${PACKAGE_BRANCH}
mkdir -p ${REPO_ROOT}

# generate a PGP key
gpg2 --batch --quick-generate-key --passphrase '' ${KEY_IDENTITY}

mkdir -p ${HOME}/.config
cat << 'EOF' > ${HOME}/.config/mock.cfg
config_opts['nosync'] = True
# config_opts['plugin_conf']['tmpfs_enable'] = True
# config_opts['plugin_conf']['tmpfs_opts'] = {}
# config_opts['plugin_conf']['tmpfs_opts']['required_ram_mb'] = 2048
# config_opts['plugin_conf']['tmpfs_opts']['max_fs_size'] = '1536m'
# config_opts['plugin_conf']['tmpfs_opts']['mode'] = '0755'
# config_opts['plugin_conf']['tmpfs_opts']['keep_mounted'] = False
# config_opts['plugin_conf']['sign_enable'] = True
# config_opts['plugin_conf']['sign_opts'] = {}
# config_opts['plugin_conf']['sign_opts']['cmd'] = 'rpmsign'
# config_opts['plugin_conf']['sign_opts']['opts'] = '--addsign {{rpms}}'
EOF

cat << EOF > ${HOME}/.rpmmacros
%_signature gpg
%_gpg_name ${KEY_IDENTITY}
%_gpg_digest_algo sha256
EOF

gpg2 --export -a ${KEY_IDENTITY} > ${HOME}/RPM-GPG-KEY-LC
rpmdev-setuptree
rpmdev-wipetree
