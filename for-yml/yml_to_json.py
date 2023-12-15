import yaml
import json


def get_yml_dict() -> dict:
    """Return a dict from a yaml file"""
    with open('ci.yml') as file:
        config = yaml.load(file, Loader=yaml.FullLoader)
        print(config)
        print(type(config))
    return config


def print_json() -> str:
    """Print a json string"""
    config = get_yml_dict()
    js = json.dumps(config, indent=2)
    print(js)
    print(type(js))
    return js


def write_json_file() -> None:
    """Write a string to a json file"""
    js_string = print_json()
    with open('js_string.json', 'w', encoding='utf-8') as string:
        string.write(js_string)


write_json_file()
