#!/bin/sh

####################################
# Example:                         #
# $> ./rutor.sh                    #
# $> ./rutor.sh 1                  #
# $> ./rutor.sh 1 Marvel           #
# $> ./rutor.sh 0 'Resident evil'  #
####################################

current_folder=$(pwd)
cd ~/PycharmProjects/github/daily-current-affairs/scripts

path='top'

if [ "$#" -eq 2 ]; then
  search=$(echo "$2" | sed 's/ /%20/g')
  path="search/${search}"
fi

if [ "$1" = '1' ]; then
  source ./antizapret_proxy.sh
fi

rutor() {
request=$(curl -s ${proxy} --max-time 3 "http://rutor.info/${path}")
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

cd "${current_folder}"

