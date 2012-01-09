#!/sbin/runscript

depend() {
    need net
}

RUN_AS=teamcity

checkconfig() {
    return 0
}

start() {
    checkconfig || return 1

    ebegin "Starting ${SVCNAME}"

    su $RUN_AS -c "cd /opt/teamcity/bin/ && /bin/bash runAll.sh start &> /dev/null"
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"
    cd /opt/teamcity/bin/
    su $RUN_AS -c "cd /opt/teamcity/bin/ && /bin/bash runAll.sh stop &> /dev/null"
    eend $?
}
