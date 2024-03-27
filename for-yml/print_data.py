import yaml

# dict objects
members = [{'name': 'Zoey', 'occupation': 'Doctor'},
           {'name': 'Zaara', 'occupation': 'Dentist'}]

print('using dump()')
print(yaml.dump(members))

print('using dump_all()')
print(yaml.dump_all(members))
