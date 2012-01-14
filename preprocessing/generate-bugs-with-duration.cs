// on Mono compile it with dmcs -r:System.Xml.Linq.dll generate.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.Diagnostics;
using System.IO;

namespace Dwdm
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length < 2) {
               Console.WriteLine("Give me path to source xml and to target arff");
               return 1;
            }

            string source = args[0];
            string target = args[1]; 
            Console.WriteLine("Started computing with source {0} and target {1}", source, target);
            var doc = XDocument.Load(source);
            var bugs = (from bug in doc.Descendants("bug")
                        select new
                        {
                            ID = int.Parse(bug.Element("bugid").Value),
                            Title = bug.Element("title").Value,
                            Status = bug.Element("status").Value,
                            Owner = bug.Element("owner").Value.Replace("%", ""),
                            Type = bug.Element("type").Value,
                            Priority = bug.Element("priority").Value,
                            Component = bug.Element("component").Value.Trim() != "" ? bug.Element("component").Value : "null",
                            Stars = int.Parse(bug.Element("stars").Value),
                            Description = bug.Element("description").Value,
                            Comments = bug.Descendants("comment").Count(),
                            closedOn = bug.Element("closedOn").Value,
                            openedDate = bug.Element("openedDate").Value
                        });

            using (StreamWriter sw = new StreamWriter(target))
            {
//                sw.WriteLine("@relation bugs");
//                sw.WriteLine("@attribute bug-id numeric");
//                sw.WriteLine("@attribute bug-title string");
//                sw.WriteLine("@attribute bug-status {" + string.Join(", ", bugs.Select(b => b.Status).Distinct()) + "}");
//                sw.WriteLine("@attribute bug-type {" + string.Join(", ", bugs.Select(b => b.Type).Distinct()) + "}");
//                sw.WriteLine("@attribute bug-priority {" + string.Join(", ", bugs.Select(b => b.Priority).Distinct()) + "}");
//                sw.WriteLine("@attribute bug-stars numeric");
//                sw.WriteLine("@attribute bug-comments numeric");
//                sw.WriteLine("@attribute bug-description string");
//                sw.WriteLine("@attribute bug-owner {" + string.Join(", ", bugs.Select(b => b.Owner).Distinct()) + "}");
//                sw.WriteLine("@attribute bug-component {" + string.Join(", ", bugs.Select(b => b.Component).Distinct()) + "}");
//                sw.WriteLine();
//                sw.WriteLine("@data");

                foreach (var bug in bugs.Where(b => b.Priority != "" && b.Type != "" && !b.Title.EndsWith("\\") && !b.Description.EndsWith("\\") && b.closedOn != "null"))
                {
                    DateTime clTime = DateTime.Parse(bug.closedOn);
                    DateTime opTime = DateTime.Parse(bug.openedDate);
                    TimeSpan duration = clTime.Subtract(opTime);
                    sw.WriteLine(string.Format(
                        "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}",
                        bug.ID, 
                        "'" + bug.Title.Replace("'", @"\'").Replace("\n", " ") + "'",
                        bug.Status, 
                        bug.Type, 
                        bug.Priority, 
                        bug.Stars, 
                        bug.Comments,
                        "'" + bug.Description.Replace("'", @"\'").Replace("\n", " ") + "'",
                        bug.Owner,
                        bug.Component != "null" ? bug.Component : "null",
                        duration.Days
					));
                }
            }
            return 0;
        }
    }
}
