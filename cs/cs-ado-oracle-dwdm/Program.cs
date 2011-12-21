using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.OracleClient;
using System.IO;

/// <summary>
/// Demonstrates how to work with SqlConnection objects
/// </summary>
class SqlConnectionDemo
{
    private static string settings_path="settings.txt";
    private static string server;
    private static string sid;
    private static string port;
    private static string user;
    private static string psswd;
    private static string CONNECTION_STRING;
    
    static void ReadSettings (){
        using (FileStream f = new FileStream(settings_path, FileMode.Open)) {
            using (StreamReader r = new StreamReader(f)) {
                server = r.ReadLine();
                sid = r.ReadLine();
                port = r.ReadLine();
                user = r.ReadLine();
                psswd = r.ReadLine();
                CONNECTION_STRING =
            "User Id=" + user + ";Password=" + psswd + ";Data Source=(DESCRIPTION=" +
            "(ADDRESS=(PROTOCOL=TCP)(HOST=" + server + ")(PORT=" + port + "))" +
            "(CONNECT_DATA=(SID=" + sid + ")));";
            }
        }
        Console.WriteLine(CONNECTION_STRING);
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
        ReadSettings();
        // ConnectAndQuery();
        PopulateDataSet();

        // Debugging
        Console.WriteLine("pres enter to exit");
        Console.ReadLine();
        
    }
}
