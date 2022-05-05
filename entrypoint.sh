#!/bin/bash -e

: ${TIMEZONE:="UTC"}
if [ -f "/usr/share/zoneinfo/${TIMEZONE}" ]; then
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
    echo ${TIMEZONE} > /etc/timezone
fi

uid=$(stat -c %u $JENKINS_HOME)
gid=$(stat -c %g $JENKINS_HOME)
[ -z "$(getent passwd $uid)" ] && usermod -u $uid $JENKINS_USER || JENKINS_USER=$(id -un $uid)
[ -z "$(getent group $gid)" ] && groupmod -g $gid $JENKINS_USER

exec gosu $JENKINS_USER tini -- /usr/local/bin/jenkins.sh "$@"
