#!/bin/bash
#
# veth-peers  OpenStack linuxbridge plugin helper
#
# chkconfig:   - 97 03
# description: Support Mapping using Linux bridging helper
### END INIT INFO

netdev_ex=br_ex
pub_br=br-ex
ex_lb="${netdev_ex}-lb"
lb_ex="lb-${netdev_ex}"
prog=veth-peers

start() {
    echo "Starting $prog: "
    ip link add ${ex_lb} type veth peer name ${lb_ex}
    ip link set ${ex_lb} up
    ip link set ${lb_ex} up
#    brctl addbr $netdev_ex
    brctl addif ${pub_br} ${lb_ex}
    echo
    return 0
}

status() {
    retval=0
    ip link show ${ex_lb}
    ip link show ${lb_ex}
    exists=$?
    if [ "$exists" -ne 0 ]; then
        # 3 means service not running
        retval=3
    fi
    echo physnet1:${lb_ex}
    echo
    return $retval
}

stop() {
    echo "Stopping $prog: "
    brctl delif ${pub_br} ${lb_ex}
#    brctl delbr ${netdev_ex}
    echo
    return 0
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}


case "$1" in
    start)
        $1
        ;;
    stop)
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        $1
        ;;
    condrestart|try-restart)
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
#        exit 2
esac
#exit $?
