#!/usr/bin/python3
# Показывает совпадения с тексте и переданной регулярке

import sys
import re

pattern =  r"'\d{1,6}\.\d{1,6}'"
string = ('\'<rating><kp_rating num_vote="6966">7.182</kp_rating>'
          '<imdb_rating num_vote="17519">7.3</imdb_rating></rating>\' ')
example = 'Пример:\n$> ./py_regexp.py ' + string + pattern

length = len(sys.argv) - 1
if length != 2:
    print(f"\033[1;31mОжидалось 2 параметра, а передано "
          f"{length}\n\033[37m{example}\033[0m")
    exit(1)

regex = sys.argv[2]
test_str = sys.argv[1]
matches = re.finditer(regex, test_str, re.MULTILINE)

for matchNum, match in enumerate(matches, start=1):
    string_match = ("Match \033[37m{matchNum}\033[0m was found at "
                    "\033[37m{start}-{end}\033[0m: \033[37m{match}\033[0m")
    print(string_match.format(matchNum=matchNum, start=match.start(), 
                              end=match.end(), match=match.group()))
    
    for groupNum in range(0, len(match.groups())):
        groupNum = groupNum + 1
        string_group = "Group {groupNum} found at {start}-{end}: {group}"
        print(string_group.format(groupNum=groupNum, 
                                  start=match.start(groupNum), 
                                  end=match.end(groupNum), 
                                  group=match.group(groupNum)))

