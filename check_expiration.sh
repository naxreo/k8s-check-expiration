#!/bin/bash

if [ -z "$EXDAY" ]; then
	EXDAY=90
fi

if [ -z "$WTID" ]; then
	WTID="DEPEND ON YOUR API"
fi


crt_names=()
crt_days=()
is_cert=0
function check_cert() {
    if [ -e /etc/kubernetes/pki/apiserver.crt ]; then
        is_cert=1
	    for crt in /etc/kubernetes/pki/*.crt; do
		    crt_names+=($crt)
		    crt_days+=($(date --date="$(openssl x509 -enddate -noout -in "$crt"|cut -d= -f 2)" --iso-8601))
	    done

	    for i in ${!crt_names[@]}; do
		    echo "${crt_days[$i]}: ${crt_names[$i]}"
	    done | sort
    else
        echo "Not found crt files"
    fi
}


function noti_expiration() {
	today=$(date "+%Y-%m-%d")
	itoday=$(date -d "${today}" "+%s")
	targetday=()
	itargetday=()

    if [ $is_cert -eq 0 ]; then
      echo "Not found crt files"
      exit
    fi
	for i in "${crt_days[@]}";do
		targetday+=($(date -d "${i} - ${EXDAY} day" --iso-8601))
		itargetday+=($(date -d "${targetday}" "+%s"))
	done

	for i in ${!crt_names[@]}; do
		if [[ "${itoday}" -gt "${itargetday[$i]}" ]]; then
			msg="`hostname -s`: ${crt_names[$i]} => less than ${EXDAY} days left from ${today}, check expiration date ${crt_days[$i]}"
			echo "$msg"
			if [ ! -e "$msg" ]; then
				send_msg "$msg"
			fi
		fi
	done
}


function send_msg() {
    ## Depend on your environment
	base_url="http://YOUR-WEBHOOK-API/send/message"
	msg=$1
	curl -XPOST -sL -H "Content-type: application/json" -d"{\"to\":$WTID, \"msg\":\"$1\"}" $base_url 1>/dev/null
}


function help() {
	echo "`basename $0` [check|noti]"
	exit
}

## main
if [ -z $1 ]; then
	help
fi

case $1 in
	"check") check_cert;;
	"noti") check_cert 1>/dev/null; noti_expiration;;
	*) help;;
esac

