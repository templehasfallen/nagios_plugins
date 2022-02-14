#!/bin/bash
ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3
AWK=`command -v awk`
SED=`command -v sed`
GREP=`command -v grep`
SS=`command -v ss`
NETSTAT=`command -v netstat`
function show_usage (){
	printf "TCP Connections Check for Nagios Core 4.x\n"
	printf "Version 0.1a\n"
	printf "\n"
    printf "Usage: $0 [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -w|--warning warning level\n"
    printf " -c|--critical critical level\n"
    printf " -o|--option all|retr|est (all | retransmitted packets | established)\n"
    printf " -h|--help, Print help\n"
	printf "\n"
	printf " TempleHasFallen (https://github.com/templehasfallen) 2022\n\n"

return $ST_UK
}
while test -n "$1"; do
    case "$1" in
        -help|-h)
            show_usage
            exit $ST_UK
            ;;
        --option|-o)
			if [[ "$2" == "all" ]]; then
				option=$2
			elif [[ "$2" == "retr" ]]; then
				option=$2
			elif [[ "$2" == "est" ]]; then
				option=$2
			else
				echo "Invalid -o or --option input"
				exit $ST_UK
			fi
            shift
            ;;
        --warning|-w)
            warning=$2
            shift
            ;;
        --critical|-c)
            critical=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            show_usage
            exit $ST_UK
            ;;
        esac
    shift
done
all_metrics(){
	TCPAll=`$SS -s | $AWK '/^TCP:/' | $AWK '{ print $2 }' `
	TCPEst=`$NETSTAT -s -t | $SED -e '/Tcp:/!d;:l;n;/^\ /!d;bl' | $GREP established | $AWK '{ print $1 }'`
	TCPRetr=`$NETSTAT -s -t | $SED -e '/Tcp:/!d;:l;n;/^\ /!d;bl' | $GREP retransmitted | $AWK '{ print $1 }'`
}


if [[ "$option" == "all" ]]; then
	if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$critical" =~ ^[0-9]+$ ]]; then
			all_metrics
			if [ "$TCPAll" -ge "$warning" ]; then
					echo "TCP Connections: CRITICAL Total: $TCPAll|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_CR
			elif [ "$TCPAll" -ge "$critical" ]; then
					echo "TCP Connections: WARNING Total: $TCPAll|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_WR
			else
					echo "TCP Connections: OK Total: $TCPAll|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_OK
			fi
	else		# If inputs are not as expected, print help. 
	printf "Please set -w and -c options correctly\n"
	fi
elif [[ "$option" == "est" ]]; then
	if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$critical" =~ ^[0-9]+$ ]]; then
			all_metrics
			if [ "$TCPEst" -ge "$warning" ]; then
					echo "TCP Established Connections: CRITICAL Total: $TCPEst|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_CR
			elif [ "$TCPEst" -ge "$critical" ]; then
					echo "TCP Established Connections: WARNING Total: $TCPEst|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_WR
			else
					echo "TCP Established Connections: OK Total: $TCPEst|tcp_total=$TCPAll;tcp_est=$TCPEst"
					exit $ST_OK
			fi
	else		# If inputs are not as expected, print help. 
	printf "Please set -w and -c options correctly\n"
	fi
elif [[ "$option" == "retr" ]]; then
	all_metrics
	echo "TCP Retransmitted Packets: OK Total: $TCPRetr|tcp_retr=$TCPRetr"
	exit $ST_OK
fi
