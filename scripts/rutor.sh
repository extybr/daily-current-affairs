#!/bin/sh

####################################
# Example:                         #
# $> ./rutor.sh                    #
# $> ./rutor.sh 1                  #
# $> ./rutor.sh 1 Marvel           #
# $> ./rutor.sh 0 'Resident evil'  #
####################################

VIOLET="\e[35m"
BLUE="\033[36m"
NORM="\e[0m"

current_folder=$(pwd)
cd ~/PycharmProjects/github/daily-current-affairs/scripts

path='top'
proxy=''

if [ "$#" -eq 2 ]; then
  search=$(echo "$2" | sed 's/ /%20/g')
  path="search/${search}"
fi

if [ "$1" = '1' ]; then
  source ./antizapret_proxy.sh
fi

rutor() {
request=$(curl -s ${proxy} --max-time 5 "http://rutor.info/${path}")
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
		number=$(expr ${count} / 2)
		printf "${BLUE}%s${NORM}. ${VIOLET}%s${NORM}\\n%s\\n\\n" "${number}" "${line}" "${temp}"
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

