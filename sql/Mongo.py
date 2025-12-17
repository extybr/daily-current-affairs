from pymongo import MongoClient

MONGO_URL = "mongodb://mongo:27017"
client = MongoClient(MONGO_URL)
db = client.admin
dbs_list = db.command("listDatabases")
print(dbs_list)
print('********')
