#!/bin/sh

if [ "$1" = '1' ]; then
  source ./antizapret_proxy.sh
fi

rutor() {
request=$(curl -s ${proxy} --max-time 3 'http://rutor.info/top')
}

main() {

if rutor; then

	response=$(echo "${request}" | grep -oP '<a href="/torrent/[^<]+' | sed 's/<a href="/http:\/\/rutor.info/g' | sed "s/\">/\\n/g" | sed -n '7,+100p')

	IFS='|'
	result=$(echo "${response}" | head -n 60)

	IFS=$'\n'
	count=1
	temp=''
	for line in ${result}
	do 
		if [ $(expr "${count}" \% 2) -eq 0 ]; then 
		printf "%s\\n%s\\n\\n" "${line}" "${temp}"
		else temp=$(echo "${line}")
		fi
		count=$(expr "${count}" + 1)
	done

else echo "timeout"
  main
fi
}

main

