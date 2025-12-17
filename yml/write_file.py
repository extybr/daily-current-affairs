import yaml

user_details = {'UserName': 'Alice',
                'Password': 'star123*',
                'phone': 3256,
                'AccessKeys': ['EmployeeTable',
                               'SoftwaresList',
                               'HardwareList']}

with open('UserDetails.yaml', 'w') as f:
    data = yaml.dump(user_details, f, sort_keys=False, default_flow_style=False)
