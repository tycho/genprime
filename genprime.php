#!/usr/bin/php
<?php

function isprime($x)
{
	if ($x < 2)
		return false;
	if ($x < 4)
		return true;
	if ($x == 5)
		return true;
	if ($x % 2 == 0)
		return false;
	if ($x % 5 == 0)
		return false;
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
}

$start = $argc > 1 ? (int)($argv[1]) : 0;
$stop = $argc > 2 ? (int)($argv[2]) + 1 : 0;
for ($x = $start; $x < $stop; $x += $start)
{
	$begin = microtime(true);
	genprime($x);
	$end = microtime(true);
	$duration = $end - $begin;
	printf ("Found %d primes in %f seconds\n", $x, $duration);
}

?>
