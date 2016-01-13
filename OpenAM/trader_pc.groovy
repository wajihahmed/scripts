logger.message("Wajih " + resourceURI + " and principal " + username);
import groovy.sql.Sql

authorized = true


def url = 'jdbc:oracle:thin:@192.168.50.14:1521:xe',
    user = 'forgerock', 
    password = 'forgerock', 
    driver = 'oracle.jdbc.OracleDriver'

def sql = Sql.newInstance(url, user, password, driver)


sql.eachRow('''SELECT * FROM RESOURCES WHERE URI LIKE \'%amount%\' ''', 
    { row -> responseAttributes.put(
      "Transaction limit is: ", [row.LIMIT]
      ) 
    }
)

  //advice.put("Limit is: ", [employees.email])

sql.close()
//logger.message("WXA row is: " + $row.URI)
