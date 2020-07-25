using System;
using System.Linq;
using EFAdventureWorks.Storing;

namespace EFAdventureWorks.Client
{
    class Program
    {
        static void Main(string[] args)
        {
            var db = new AdventureWorks2017Context();

            foreach(var p in db.Person.ToList())
            {
                Console.WriteLine($"{p.FirstName} {p.LastName}");
            }
        }
    }
}
