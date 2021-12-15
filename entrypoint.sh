#!/bin/bash -e

: ${TIMEZONE:="UTC"}
if [ -f "/usr/share/zoneinfo/${TIMEZONE}" ]; then
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
    echo ${TIMEZONE} > /etc/timezone
fi

uid=$(stat -c %u $JENKINS_HOME)
gid=$(stat -c %g $JENKINS_HOME)
u=$(getent passwd $uid | cut -d: -f1)

if [ -z "$u" ]; then
    usermod -u $uid $JENKINS_USER
else
    JENKINS_USER=$u
fi

if [ -z "$(getent group $gid)" ]; then
    groupmod -g $gid $JENKINS_USER
fi

exec gosu $JENKINS_USER tini -- /usr/local/bin/jenkins.sh "$@"
