using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.OracleClient;

/// <summary>
/// Demonstrates how to work with SqlConnection objects
/// </summary>
class SqlConnectionDemo
{
    private static string server = "alcor.inf.unibz.it";
    private static string sid = "orcl";
    private static string port = "1521";
    private static string user = "oplatek";
    private static string psswd = "Cu8naeHu";
    private static string CONNECTION_STRING =
  "User Id="+user+";Password="+psswd+";Data Source=(DESCRIPTION=" +
  "(ADDRESS=(PROTOCOL=TCP)(HOST="+server+")(PORT="+port+"))"+
  "(CONNECT_DATA=(SID="+sid+")));";

    public static SqlConnectionDemo {
        FileStream f = new todo ("settings.txt") ;
        server 
        sid
        port
        user = f.Readline();
        psswd = f.ReadLine();
    }

    static private void ConnectAndQuery()
    {
        string table = "sub_date";
        OracleConnection connection =null;
        try
        {
            connection = new OracleConnection();
            connection.ConnectionString = CONNECTION_STRING;
            connection.Open();
            Console.WriteLine("State: {0}", connection.State);
            Console.WriteLine("ConnectionString: {0}",
                              connection.ConnectionString);

            OracleCommand command = connection.CreateCommand();
            string sql = "SELECT * FROM " + table;
            command.CommandText = sql;

            OracleDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                decimal year = (decimal)reader["year"];
                Console.WriteLine(year);
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }
        finally {
            if (connection != null)
                connection.Close();
        }
    }

    static private void PopulateDataSet()
    {
        string table = "sub_date";
        OracleConnection connection = null;
        try
        {
            connection = new OracleConnection();
            connection.ConnectionString = CONNECTION_STRING;
            
            Console.WriteLine("State: {0}", connection.State);
            Console.WriteLine("ConnectionString: {0}",
                              connection.ConnectionString);

            OracleCommand command = connection.CreateCommand();
            string sql = "SELECT * FROM " + table;
            command.CommandText = sql;
                        
            OracleDataAdapter oracleAdapter = new OracleDataAdapter();
            oracleAdapter.SelectCommand = command;

            DataSet myDataSet = new DataSet();
            connection.Open();
            // retrieving rows
            oracleAdapter.Fill(myDataSet,table);

            DataTable myDataTable = myDataSet.Tables[table];

            foreach (DataRow myDataRow in myDataTable.Rows)
            {
                Console.WriteLine("day = " + myDataRow["day"]);
                Console.WriteLine("month = " + myDataRow["month"]);
                Console.WriteLine("year = " + myDataRow["year"]);
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }
        finally
        {
            if (connection != null)
                connection.Close();
        }
    }
    static void Main()
    {
        // ConnectAndQuery();
        PopulateDataSet();
        Console.ReadLine();
        /*
        // 1. Instantiate the connection
        SqlConnection conn = new SqlConnection(
            "Data Source=(local);Initial Catalog=Northwind;Integrated Security=SSPI");

        SqlDataReader rdr = null;
        
        try
        {
            // 2. Open the connection
            conn.Open();

            // 3. Pass the connection to a command object
            SqlCommand cmd = new SqlCommand("select * from Customers", conn);

            //
            // 4. Use the connection
            //

            // get query results
            rdr = cmd.ExecuteReader();

            // print the CustomerID of each record
            while (rdr.Read())
            {
                Console.WriteLine(rdr[0]);
            }
        }
        finally
        {
            // close the reader
            if (rdr != null)
            {
                rdr.Close();
            }

            // 5. Close the connection
            if (conn != null)
            {
                conn.Close();
            }
        }
        */
    }
}
