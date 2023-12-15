#pip install PyYAML
import yaml

with open('ci.yml') as file:
    configdata = yaml.load(file, Loader=yaml.FullLoader)
    on = configdata[True]['workflow_call']
    jobs = configdata['jobs']
    print('\n', on, '\n\n', jobs)
