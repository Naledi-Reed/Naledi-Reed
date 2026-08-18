using System;

namespace StudentQualificationApp
{
    internal class Program
    {
        static void Main(string[] args)
        {
            double test1;
            double test2;
            double assignment1;
            double project;

            Console.Write("Enter Test 1 mark: ");
            test1 = Convert.ToDouble(Console.ReadLine());

            Console.Write("Enter Test 2 mark: ");
            test2 = Convert.ToDouble(Console.ReadLine());

            Console.Write("Enter Assignment 1 mark: ");
            assignment1 = Convert.ToDouble(Console.ReadLine());

            Console.Write("Enter Project mark: ");
            project = Convert.ToDouble(Console.ReadLine());

            double weightedAverage =
                (test1 * 0.30) +
                (test2 * 0.50) +
                (assignment1 * 0.10) +
                (project * 0.10);

            Console.WriteLine();
            Console.WriteLine("Weighted Average: " + weightedAverage);

            if (weightedAverage > 50)
                Console.WriteLine("Student qualifies to write exam.");
            else
                Console.WriteLine("Student does NOT qualify to write exam.");

            Console.ReadKey();
        }
    }
}
