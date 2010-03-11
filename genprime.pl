#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes;

sub isprime {
	my ($x, $lim, $y);
	$x = $_[0];
	if ($x < 2) {
		return 0;
	}
	if ($x == 2) {
		return 1;
	}
	if ($x % 2 == 0) {
		return 0;
	}
	if ($x < 9) {
		return 1;
	}
	if (($x + 1) % 6 != 0) {
		if (($x - 1) % 6 != 0) {
			return 0;
		}
	}
	$lim = sqrt($x) + 1.0;
	for ($y = 3; $y < $lim; $y += 2)
	{
		if ($x % $y == 0)
		{
			return 0;
		}
	}
	return 1;
}

sub genprime {
	my ($max, $count, $current);
	$max = $_[0];
	$count = 0;
	$current = 1;
	while ($count < $max)
	{
		if (isprime($current) != 0)
		{
			$count = $count + 1;
		}
		$current = $current + 1;
	}
	return $current - 1;
}

my $argc = @ARGV + 1;

my ($start, $stop);

if ($argc > 1) {
	$start = $ARGV[0] + 0;
} else {
	$start = 0;
}
if ($argc > 2) {
	$stop = $ARGV[1] + 1;
} else {
	$stop = 0;
}

my ($x, $begin, $end, $duration, $last);

for ($x = $start; $x < $stop; $x = $x + $start)
{
	$begin = Time::HiRes::time();
	$last = genprime($x);
	$end = Time::HiRes::time();
	$duration = $end - $begin;
	printf "Found %8d primes in %10.5f seconds (last was %10d)\n",
		$x, $duration, $last;
}
