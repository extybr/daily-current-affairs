from PyQt5 import QtSql
conn = QtSql.QSqlDatabase.addDatabase('QSQLITE')
conn.setDatabaseName(self.db)
conn.open()
query = QtSql.QSqlQuery()
data = query.exec("select * from headhunter")
print(data)   // исправить


// Показывает число строк
// https://doc.qt.io/qtforpython-6/PySide6/QtSql/index.html#module-PySide6.QtSql
q = QtSql.QSqlQuery("SELECT * FROM headhunter")
rec = q.record()
print("Number of columns: ", rec.count())