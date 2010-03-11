#!/usr/bin/php
<?php

function isprime($x)
{
	if ($x < 2)
		return false;
	if ($x == 2)
		return true;
	if ($x % 2 == 0)
		return false;
	if ($x < 9)
		return true;
	if (($x + 1) % 6 != 0)
		if (($x - 1) % 6 != 0)
			return false;
	$lim = sqrt($x) + 1.0;
	for ($y = 3; $y < $lim; $y += 2)
	{
		if ($x % $y == 0)
			return false;
	}
	return true;
}

function genprime($max)
{
	$count = 0;
	$current = 1;
	while ($count < $max)
	{
		if (isprime($current))
			$count++;
		$current++;
	}
	return $current - 1;
}

$start = $argc > 1 ? (int)($argv[1]) : 0;
$stop = $argc > 2 ? (int)($argv[2]) + 1 : 0;
for ($x = $start; $x < $stop; $x += $start)
{
	$begin = microtime(true);
	$last = genprime($x);
	$end = microtime(true);
	$duration = $end - $begin;
	printf ("Found %8d primes in %10.5f seconds (last was %10d)\n",
		$x, $duration, $last);
}

?>
