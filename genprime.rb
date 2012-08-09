#!/usr/bin/ruby

$primes = Array.new

def isprime(x)
	if x < 2
		return 0
	end
	if x == 2
		return 1
	end
	if x % 2 == 0
		return 0
	end
	if x < 9
		return 1
	end
	if (x + 1) % 6 != 0
		if (x - 1) % 6 != 0
			return 0
		end
	end
	lim=Math.sqrt(x).to_i+1
	y = 1
	$primes.each do |v|
		y = v
		if y >= lim
			return 1
		end
		if x % y == 0
			return 0
		end
	end
	y += 2
	while y <= lim
		if x % y == 0
			return 0
		end
		y += 2
	end
	return 1
end

def genprime(max)
	count = 0
	current = 1
	while count<max
		if isprime(current) != 0
			if $primes.length < 1 or $primes[-1] < current
				$primes << current
			end
			count += 1
		end
		current += 1
	end
	return current - 1
end

start = ARGV[0].to_i
stop = ARGV[1].to_i + 1
i = start
if start == 0
	Process.exit
end
until i >= stop
	starttime = Time.now
	last = genprime(i)
	endtime = Time.now
	duration = endtime - starttime
	printf "Found %8d primes in %10.5f seconds (last was %10d)\n", i, duration, last
	i += start
end
