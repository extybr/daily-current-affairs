import cx_Oracle
# python -m pip install cx_Oracle --upgrade --user

conn = None
try:
    dsn_tns = cx_Oracle.makedsn('Host Name', port=1512, service_name='Service Name')
    conn = cx_Oracle.connect(user=r'User Name', password='Personal Password', dsn=dsn_tns,
                             encoding='UTF-8')
    c = conn.cursor()
    c.execute('select * from database.table')
    for row in c:
        print(row[0], '-', row[1])
except cx_Oracle.Error as error:
    print(error)
finally:
    # release the connection
    if conn:
        conn.close()

