#!/bin/bash
# $> ./map.sh London
# Запуск карты, указанного города
# WARNING: необходимо наличие TkinterMapView

white="\e[37m"
violet="\e[35m"
blue="\e[36m"
dblue="\e[34m"
yellow="\e[33m"
normal="\e[0m"
red="\e[31m"

file_map='https://github.com/TomSchimansky/TkinterMapView/blob/main/examples/map_with_customtkinter.py'
requirements='https://github.com/TomSchimansky/TkinterMapView/blob/main/requirements.txt'

if ! [[ -d ~/PycharmProjects/temp/TkinterMapView ]]; then 
  echo -e "${red}not found${normal} folder <${white}TkinterMapView${normal}>"
  echo -e "${blue}wget${normal} ${file_map}\n${blue}wget${normal} ${requirements}"
  echo -e "'${white}pip install -r requirements.txt${normal}' or '${white}pip install tkintermapview${normal}'"
  echo -e "${blue}mv${normal} ${violet}map_with_customtkinter.py${normal} ${dblue}main.py${normal}"
  echo -e "${blue}sed${normal} -i ${yellow}'6i\CITY = 'New-York''${normal} ${dblue}main.py${normal}"
  echo -e "${blue}sed${normal} -i ${yellow}'7i\if len(sys.argv) == 2:'${normal} ${dblue}main.py${normal}"
  echo -e "${blue}sed${normal} -i ${yellow}'8i\    CITY = sys.argv[1]'${normal} ${dblue}main.py${normal}"
  exit 0
fi

cd ~/PycharmProjects/temp/TkinterMapView

map() {
  #.venv/bin/python main.py
  uv run main.py
}

fix() {
  sed -i '347i\\n' "${osm}"
  sed -i '348i\    def _build_headers(self, provider_key, **kwargs):' "${osm}"
  sed -i '349i\        """Will be overridden according to the targetted web service"""' "${osm}"
  sed -i '350i\        return {"User-Agent": "My User Agent 1.0"}' "${osm}"
}

pwd=$(pwd)
python_version=$(ls ${pwd}/.venv/lib)
osm="${pwd}/.venv/lib/${python_version}/site-packages/geocoder/osm.py"
if [[ $(grep '_build_headers' "${osm}") ]]
then
  if [ "$#" -gt 1 ]
    then echo -e "${white}ожидалось не более 1 параметра, а передано $#${normal}"
  elif [ "$#" -eq 1 ]
    then uv run main.py "$1"
  else map
  fi
else echo -e "${white}*** fix ***${normal}" && fix && map
fi

