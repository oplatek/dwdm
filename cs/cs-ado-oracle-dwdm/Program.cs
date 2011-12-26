using System;
using System.Data;
using System.Data.Common;
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

    static private void XML2ShowSchema(bool printSchema) {
        string xmlpath = "E:/work/unibz/comp_lingvistics/project/wordnet-cz.xml";
        DataSet xmlDataSet = new DataSet();
        
        using (FileStream filestream = File.OpenRead(xmlpath)) {
            using (BufferedStream buffered = new BufferedStream(filestream)) {
                xmlDataSet.ReadXml(buffered);
                if (printSchema) {
                    Console.WriteLine(xmlDataSet.GetXmlSchema());
                }
                foreach (DataTable t in xmlDataSet.Tables) {
                    Console.WriteLine("create table {0} (", t.TableName);
                    foreach (DataColumn c in t.Columns) {
                        Console.WriteLine("  {0} {1},", c.ColumnName, c.DataType.ToString());
                    }                            
                    Console.WriteLine(");");
                }                                    
            }// end using
        }// end using        
    }

    static private void XML2sql() {
        string xmlpath = "E:/work/unibz/comp_lingvistics/project/wordnet-cz.xml";
        DataSet xmlDataSet = new DataSet();
        string sqlpath = "E:/downloads/xml2sql.sql";
        string tablePrefix = "OP_CL_";
        using (FileStream filestream = File.OpenRead(xmlpath)) {
            using (BufferedStream buffered = new BufferedStream(filestream)) {
                xmlDataSet.ReadXml(buffered);
                StreamWriter w = new StreamWriter(sqlpath);
                Console.WriteLine("Loading finished .. Writing started");
                foreach (DataTable t in xmlDataSet.Tables) {                                        
                    string insert_start = "INSERT INTO " + tablePrefix + t.TableName + " VALUES (";                        
                    foreach (DataRow r in t.Rows) {
                        w.Write(insert_start);
                        int i;
                        DataColumn c;
                        for(i = 0; i < t.Columns.Count -1; ++i) {
                            c = t.Columns[i];
                            if (c.DataType.Equals(typeof(Int32))) {
                                string s = r[c].ToString();
                                if (s == "") {
                                    w.Write("NULL");
                                }
                                else {
                                    w.Write(s);
                                }
                            }
                            else { 
                                //string
                                
                                string s = r[c].ToString();
                                if (s == "") {
                                    w.Write("NULL");
                                }
                                else {
                                    w.Write("'");
                                    w.Write(s);
                                    w.Write("'");
                                }
                            }
                            
                            w.Write(", ");
                        }        
                        // END FOR
                        c = t.Columns[i];
                        if (c.DataType.Equals(typeof(Int32))) {
                            string s = r[c].ToString();
                            if (s == "") {
                                w.Write("NULL");
                            }
                            else {
                                w.Write(s);
                            }
                        }
                        else {
                            //string

                            string s = r[c].ToString();
                            if (s == "") {
                                w.Write("NULL");
                            }
                            else {
                                w.Write("'");
                                w.Write(s);
                                w.Write("'");
                            }
                        }                        
                        w.WriteLine(");");                                                
                    }                    
                }
                w.Close();
            }// end using
        }// end using        
    }


    static private void LoadXML2DataSet(bool printSchema) {
        string xmlpath = "E:/work/unibz/comp_lingvistics/project/wordnet-cz.xml";
        string tablePrefix = "OP_CL_";
        
        using (FileStream filestream = File.OpenRead(xmlpath)) {
            using (BufferedStream buffered = new BufferedStream(filestream)) {
                DataSet xmlDataSet = new DataSet();
                xmlDataSet.ReadXml(buffered);
                
                using (OracleConnection connection = new OracleConnection()) {                
                    connection.ConnectionString = CONNECTION_STRING;
                    connection.Open();
                   
                    foreach (DataTable t in xmlDataSet.Tables) {
                        OracleDataAdapter oracleAdapter = new OracleDataAdapter();
                        string table_name = tablePrefix + t.TableName;
                        string sql_str = "INSERT INTO " + table_name + " VALUES (";                        
                        foreach (DataColumn c in t.Columns) {
                            sql_str = sql_str + "@" + c.ColumnName + ", ";
                            bool intIs= c.DataType.Equals(typeof(Int32));
                            oracleAdapter.InsertCommand.Parameters.Add("@" + c.ColumnName, 
                                intIs ? OracleType.Number : OracleType.NVarChar, 
                                intIs ? 2 : 255, c.ColumnName);

                        }
                        sql_str = sql_str.Substring(0, sql_str.Length - 2) + ");";

                        Console.WriteLine(sql_str);
                        oracleAdapter.InsertCommand = new OracleCommand(sql_str,connection);
                        
                        oracleAdapter.Update(t);
                    }                    
                } // end using oracle
            }// end using
        }// end using        
    }

    static void Main()
    {
        XML2sql();
        //ReadSettings();

        //LoadXML2DataSet(false);
        // ConnectAndQuery();
        //PopulateDataSet();

        // Debugging
        Console.WriteLine("pres enter to exit");
        Console.ReadLine();
        
    }
}
