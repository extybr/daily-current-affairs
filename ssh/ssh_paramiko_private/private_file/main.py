import paramiko
from pathlib import Path
from config import Config, load_config

configurate: Config = load_config('.env')
host: configurate = configurate.configuration.host
port: configurate = configurate.configuration.port
user: configurate = configurate.configuration.user
secret: configurate = configurate.configuration.password
private_file: configurate = configurate.configuration.filename

path_file = (Path('private') / private_file).absolute()
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
key = paramiko.RSAKey.from_private_key_file(filename=str(path_file),
                                            password=secret)
client.connect(hostname=host, port=port, username=user, pkey=key)
stdin, stdout, stderr = client.exec_command('netstat -ntuop')
output = stdout.readlines()
for line in output:
    print(line.strip())
client.close()

