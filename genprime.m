#import <Foundation/Foundation.h>
#import <math.h>
#import <stdio.h>
#import <stdlib.h>
#import <sys/time.h>

typedef unsigned long prime_t;

@interface GenPrime : NSObject
- (BOOL) isprime:(prime_t)x;
- (prime_t) genprime:(prime_t)max;
@end

@implementation GenPrime
- (BOOL)isprime:(prime_t)x
{
	prime_t lim, y;
	if (x < 2)
		return NO;
	if (x < 4)
		return YES;
	if (x == 5)
		return YES;
	if (x % 2 == 0)
		return NO;
	if (x % 5 == 0)
		return NO;
	if ((x + 1) % 6 != 0)
		if ((x - 1) % 6 != 0)
			return NO;
	lim = (prime_t)(sqrt((double)x) + 1.0f);
	for (y = 3; y < lim; y += 2)
	{
		if (x % y == 0)
			return NO;
	}
	return YES;
}

- (prime_t) genprime:(prime_t)max
{
	prime_t count = 0,
		current = 1;
	while (count < max)
	{
		if ([self isprime:current])
			count++;
		current++;
	}
	return current - 1;
}
@end

int main(int argc, char **argv)
{
	prime_t start = argc > 1 ? atol(argv[1]) : 0,
		stop = argc > 2 ? atol(argv[2]) + 1 : 0,
		x, last;
	struct timeval begin, end;
	double duration;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	GenPrime *gp = [[[GenPrime alloc] init] autorelease];

	for (x = start; x < stop; x += start)
	{
		gettimeofday(&begin, NULL);
		last = [gp genprime:x];
		gettimeofday(&end, NULL);
		duration = (double)(end.tv_sec - begin.tv_sec) +
			((double)(end.tv_usec) - (double)(begin.tv_usec)) / 1000000.0;
		printf("Found %8lu primes in %10.5f seconds (last was %10lu)\n", x, (float)duration, last);
	}

	[pool release];

	return 0;
}
