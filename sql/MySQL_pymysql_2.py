import pymysql.cursors


def get_connection():
    connecting = pymysql.connect(host='localhost',
                                 user='root',
                                 password='my-pass',
                                 db='skillbox',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)
    print("connect successful!!")
    return connecting


connection = get_connection()
try:
    with connection.cursor() as cursor:
        # Выполнить команду запроса (Execute Query).
        cursor.execute("SELECT * FROM courses WHERE type = 'Programming'")
        print(f"cursor.description: {cursor.description}\n")
        for row in cursor:
            print(row)
finally:
    connection.close()
