#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

typedef unsigned long prime_t;
typedef int BOOL;
#define TRUE -1
#define FALSE 0

prime_t primes[65536];
const prime_t *primeEnd = &primes[65535];
prime_t *primePtr = primes;

BOOL isprime(prime_t x)
{
	prime_t lim, y, *p;
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
	y = 1;
	for (p = primes; p != primePtr; p++)
	{
		y = *p;
		if (y >= lim)
			return TRUE;
		if (x % y == 0)
			return FALSE;
	}
	for (y += 2; y < lim; y += 2)
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
		if (isprime(current)) {
			if (primePtr < primeEnd &&
			    (primePtr == primes || *(primePtr - 1) < current))
			{
				*primePtr++ = current;
			}
			count++;
		}
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
