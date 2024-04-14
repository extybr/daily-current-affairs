#!/bin/sh

# раскраска текста
WHITE="\033[37m"
VIOLET="\033[35m"
BLUE="\033[36m"
DBLUE="\033[34m"
YELLOW="\033[1;33m"
NORMAL="\033[0m"

# данные для запроса на сайт
asu="&text=инженер%20асу"
dev="&text=Системный%20администратор%20Linux"
search="clusters=true&enable_snippets=true&st=searchVacancy"
time="&order_by=publication_time"  # сортировать по дате
vacancy="${asu}"  # название вакансии
pages="&per_page=100"  # число страниц в ответе
period="&period=1"  # искать за этот период, в днях
area="&area=113"  # регион для поиска

# проверка параметра на валидность
if [ "$#" -gt 3 ]
	then echo -e "${WHITE}ожидалось не более 3 параметров, а передано $#${NORMAL}"
	exit 1
elif [ "$#" -eq 0 ]
	then salary="&only_with_salary=true&salary=250000"
elif [ "$#" -eq 1 ]
	then
	if ! [ "$1" -ge 0 ] 2>/dev/null
		then echo -e "${WHITE}ожидалось число${NORMAL}"
		exit 1
	fi
	salary="&only_with_salary=true&salary=$1"
elif [ "$#" -eq 2 ]
	then
	if ! [ "$2" -ge 0 ] 2>/dev/null
		then echo -e "${WHITE}2-ым параметром ожидалось число${NORMAL}"
		exit 1
	fi
	vacancy=$(echo "&text=$1" | sed "s/ /%20/g")
	salary="&only_with_salary=true&salary=$2"
	if [ "$1" = "asu" ]
		then vacancy="${asu}"
	elif [ "$1" = "dev" ]
		then vacancy="${dev}"
	fi
elif [ "$#" -eq 3 ]
	then
	if ! [ "$2" -ge 0 ] 2>/dev/null || ! [ "$3" -ge 0 ] 2>/dev/null
		then echo -e "${WHITE}2-ым и 3-им параметром ожидались числа${NORMAL}"
		exit 1
	fi
	vacancy=$(echo "&text=$1" | sed "s/ /%20/g")
	salary="&only_with_salary=true&salary=$2"
	period="&period=$3"
	if [ "$1" = "asu" ]
		then vacancy="${asu}"
	elif [ "$1" = "dev" ]
		then vacancy="${dev}"
	fi
fi

# создание запроса к сайту hh.tu
request=$(curl -s --max-time 10 "https://api.hh.ru/vacancies?${search}${time}${salary}${vacancy}${pages}${period}${area}")

# если данные вернулись проходим по ним циклами и парсим неодходимые данные
if [ ${#request} -gt 0 ]
  then
  for page in {0..100}
	do
	  
	  # название вакансии, а конце вывод количества вакансий
		name=$(printf "%s" "${request}" | jq -r ".items.[${page}].name")
		found=$(printf "%s" "${request}" | jq -r ".found")
		if [ "${name}" = "null" ] || [ "${page}" -eq 100 ]
			then echo -e "${WHITE}${name}${NORMAL}" | sed "s/null/--- найдено ${found} вакансий ---/g"
			break
		fi	
		echo -e "${WHITE}${name}${NORMAL}"
		
		# название компании
		company=$(printf "%s" "${request}" | jq -r ".items.[${page}].employer.name")
		echo -e "фирма: ${VIOLET}${company}${NORMAL}"
		
		# время публикации вакансии
		date=$(printf "%s" "${request}" | jq -r ".items.[${page}].published_at" | sed "s/+.*//g" | tr "T" " ")
		echo -e "дата: ${DBLUE}${date}${NORMAL}"
		
		# размер зарплаты от и до
		from=$(printf "%s" "${request}" | jq -r ".items.[${page}].salary.from")
		to=$(printf "%s" "${request}" | jq -r ".items.[${page}].salary.to")
		if [ ${from} = "null" ]; then from="😳"; elif [ ${to} = "null" ]; then to="😳"; fi
		echo -e "зарплата: ${BLUE}${from}${NORMAL} - ${BLUE}${to}${NORMAL}"
		
		# график работы
		schedule=$(printf "%s" "${request}" | jq -r ".items.[${page}].schedule.name" 2>/dev/null)
		echo -e "график работы: ${DBLUE}${schedule}${NORMAL}"
		
		# адрес для публикации
		area_name=$(printf "%s" "${request}" | jq -r ".items.[${page}].area.name" 2>/dev/null)
		echo -e "адрес для публикации: ${BLUE}${area_name}${NORMAL}"
		
		# адрес регистрации фирмы
		address=$(printf "%s" "${request}" | jq -r ".items.[${page}].address.raw" 2>/dev/null)
		if [[ "${address}" = "null" ]]; then address="😳"; fi
		echo -e "адрес регистрации фирмы: ${BLUE}${address}${NORMAL}"
		
		# прямая ссылка на вакансию
		alternate_url=$(printf "%s" "${request}" | jq -r ".items.[${page}].alternate_url")
		echo -e "ссылка: ${YELLOW}${alternate_url}${NORMAL}"
		echo
		
	done
fi
