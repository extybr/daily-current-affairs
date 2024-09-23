#!/bin/sh
##############################################################
# $> ./rutor.sh                                              #
# $> ./rutor.sh 1                                            #
# $> ./rutor.sh 1 Marvel                                     #
# $> ./rutor.sh 0 'Resident evil'                            #
# $> ./rutor.sh 0 'http://rutor.info/torrent/999364'         #
# $> ./rutor.sh 1 'http://tracker.rutor.is/torrent/999364'   #
##############################################################

violet="\e[35m"
blue="\e[36m"
red="\e[31m"
normal="\e[0m"

path='top'
proxy=''

if [ "$#" -eq 2 ]; then
  search=$(echo "$2" | sed 's/ /%20/g')
  path="search/${search}"
fi

if [ "$1" = '1' ]; then
  cd ~/PycharmProjects/github/daily-current-affairs/scripts
  source ./antizapret_proxy.sh
fi

rutor() {
request=$(curl -s ${proxy} --max-time 5 "http://rutor.info/${path}")
}

main() {

if rutor; then
  response=$(echo "${request}" | grep -oP '<a href="/torrent/[^<]+' | \
  sed 's/<a href="/http:\/\/rutor.info/g' | \
  sed "s/\">/\\n/g" | tail -n +7)

  IFS='|'
  result=$(echo "${response}" | head -n 60)

  IFS=$'\n'
  count=1
  temp=''
  for line in ${result}
  do 
    if [ $(expr "${count}" \% 2) -eq 0 ]; then 
      number=$(expr ${count} / 2)
      printf "${blue}%s${normal}. ${violet}%s${normal}\\n%s\\n\\n" "${number}" "${line}" "${temp}"
    else temp=$(echo "${line}")
    fi
    count=$(expr "${count}" + 1)
  done

else echo "timeout"
  main
fi
}

magnet() {
url="$1"
request=$(curl -s ${proxy} --max-time 5 "${url}" | grep -oP 'magnet[^<]+ce' | grep amp)
echo -e "\n${blue}${request}${normal}\n"
if command -v xclip > /dev/null
  then echo "${request}" | xclip -sel clip
  else echo -e "xclip: ${red}not found${normal}"
fi
}

if [[ ${search%'rutor'*} = 'http://' ]] || [[ ${search%'tracker.rutor'*} = 'http://' ]]
  then magnet "$2"
  else main
fi

