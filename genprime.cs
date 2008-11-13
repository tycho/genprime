// Main.cs created with MonoDevelop
// User: steven at 04:10 11/11/2008
//
// To change standard headers go to Edit->Preferences->Coding->Standard Headers
//
using System;
using System.Diagnostics;

namespace GenPrime
{
	class GenPrime
	{
		private static bool isprime(ulong x)
		{
			ulong lim, y;
			if (x < 2)
				return false;
			if (x < 4)
				return true;
			if (x == 5)
				return true;
			if (x % 2 == 0)
				return false;
			if (x % 5 == 0)
				return false;
			if ((x + 1) % 6 != 0)
				if ((x - 1) % 6 != 0)
					return false;
			lim = (ulong)(Math.Sqrt((double)x) + 1.0f);
			for (y = 3; y < lim; y += 2)
			{
				if (x % y == 0)
					return false;
			}
			return true;
		}
		
		private static ulong genprime(ulong max)
		{
			ulong count = 0,
			     current = 1;
			while (count < max)
			{
				if (isprime(current))
					count++;
				current++;
			}
			return current - 1;
		}

		public static void Main(string[] args)
		{
	                ulong start = ulong.Parse(args[0]), stop = ulong.Parse(args[1]) + 1, last;
			Stopwatch sw = new Stopwatch();
	                for ( ulong x = start; x < stop; x += start )
	                {
	                        sw.Start();
				last = genprime(x);
	                        sw.Stop();
				double duration = (double)sw.ElapsedTicks / (double)Stopwatch.Frequency;
				Console.WriteLine( "Found {0,8} primes in {1,10:0.00000} seconds (last was {2,10})",
					x, duration, last);
	                }
		}
	}
}
