#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#ifdef USE_FLOATS
typedef float prime_t;
#	define MOD(x,y) fmodf((x),(y))
#else
typedef unsigned long prime_t;
#	define MOD(x,y) ((x) % (y))
#endif

typedef int BOOL;
#define TRUE -1
#define FALSE 0

BOOL isprime(unsigned long x)
{
	prime_t lim, v, y;
	if (x < 2)
		return FALSE;
	if (x < 4)
		return TRUE;
	if (x == 5)
		return TRUE;
	if (x % 2 == 0)
		return FALSE;
	if (x % 5 == 0)
		return FALSE;
	if ((x + 1) % 6 != 0)
		if ((x - 1) % 6 != 0)
			return FALSE;
	v = (prime_t)x;
	lim = (prime_t)(sqrt((float)v) + 1.0f);
	for (y = 3; y < lim; y += 2)
	{
		if (MOD(v, y) == 0)
			return FALSE;
	}
	return TRUE;
}

unsigned long genprime(unsigned long max)
{
	unsigned long count = 0,
		current = 1;
	while (count < max)
	{
		if (isprime(current))
			count++;
		current++;
	}
	return current - 1;
}

int main(int argc, char **argv)
{
	unsigned long start = argc > 1 ? atol(argv[1]) : 0,
		stop = argc > 2 ? atol(argv[2]) + 1 : 0,
		x, last;
	struct timeval begin, end;
	double duration;
	for (x = start; x < stop; x += start)
	{
		gettimeofday(&begin, NULL);
		last = genprime(x);
		gettimeofday(&end, NULL);
		duration = (double)(end.tv_sec - begin.tv_sec) +
			((double)(end.tv_usec) - (double)(begin.tv_usec)) / 1000000.0;
		printf ("Found %8lu primes in %10.5f seconds (last was %10lu)\n",
			x, (float)duration, last);
	}
	return 0;
}
