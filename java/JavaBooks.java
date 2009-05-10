// queries the books table in database javaBooks on local

import java.sql.*;

public class JavaBooks {
    public static void main(String[] args) {

        try {
            Class.forName("org.gjt.mm.mysql.Driver").newInstance();
        }
        catch (Exception E) {
            System.err.println("Unable to load driver");
            E.printStackTrace();
        }

        try {
            Connection C = DriverManager.getConnection(
              "jdbc:mysql://multivac.sdsc.edu/wbluhm","wbluhm","");
            Statement Stmt = C.createStatement();

            ResultSet RS = Stmt.executeQuery
            ("SELECT id, title " +
             " FROM books WHERE title=\"doe\"");

            while (RS.next()) {
                 System.out.print("\"" + RS.getString(1) + "\"");
                 System.out.println(": " + RS.getString(2));
            }
            C.close();
            RS.close();
            Stmt.close();
        }
        catch (SQLException E) {
            System.out.println("SQLException: " + E.getMessage());
            System.out.println("SQLState:     " + E.getSQLState());
            System.out.println("VendorError:  " + E.getErrorCode());
        }
    }
}
