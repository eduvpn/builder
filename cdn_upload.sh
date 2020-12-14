#!/bin/sh

# CDN
SERVER_LIST="eduvpn-repo@tromso-cdn.eduroam.no eduvpn-repo@ifi2-cdn.eduroam.no"
for SERVER in ${SERVER_LIST}; do
	echo "${SERVER}..."
        # CentOS / Fedora
	rsync -e ssh -rltO --delete ${HOME}/repo/v2/results/* "${SERVER}:/srv/repo.eduvpn.org/www/v2/rpm" || echo "FAIL ${SERVER}"
done
