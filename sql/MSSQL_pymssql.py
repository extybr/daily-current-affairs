import pymssql

conn = pymssql.connect(server='yourserver.database.windows.net', user='yourusername@yourserver',
                       password='yourpassword', database='AdventureWorks')
cursor = conn.cursor()
cursor.execute('SELECT c.CustomerID, c.CompanyName,COUNT(soh.SalesOrderID) AS OrderCount'
               ' FROM SalesLT.Customer AS c LEFT OUTER JOIN SalesLT.SalesOrderHeader AS'
               ' soh ON c.CustomerID = soh.CustomerID GROUP BY c.CustomerID, c.CompanyName'
               ' ORDER BY OrderCount DESC;')

# cursor.execute("INSERT SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice,"
#                " SellStartDate) OUTPUT INSERTED.ProductID VALUES ('SQL Server Express',"
#                " 'SQLEXPRESS', 0, 0, CURRENT_TIMESTAMP)")

row = cursor.fetchone()
while row:
    print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
    row = cursor.fetchone()
    