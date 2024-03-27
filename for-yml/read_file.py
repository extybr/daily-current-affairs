# import pyyaml module
import yaml
from yaml.loader import SafeLoader

# Open the file and load the file
with open('ci.yml') as f:
    data = yaml.load(f, Loader=SafeLoader)
    print(data)
    