#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

typedef unsigned long prime_t;
typedef int BOOL;
#define TRUE -1
#define FALSE 0

BOOL isprime(prime_t x)
{
	prime_t lim, y;
	if (x < 2)
		return FALSE;
	if (x == 2)
		return TRUE;
	if (x % 2 == 0)
		return FALSE;
	if (x < 9)
		return TRUE;
	if ((x + 1) % 6 != 0)
		if ((x - 1) % 6 != 0)
			return FALSE;
	lim = (prime_t)(sqrt((double)x) + 1.0f);
	for (y = 3; y < lim; y += 2)
	{
		if (x % y == 0)
			return FALSE;
	}
	return TRUE;
}

prime_t genprime(prime_t max)
{
	prime_t count = 0,
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
	prime_t start = argc > 1 ? atol(argv[1]) : 0,
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
