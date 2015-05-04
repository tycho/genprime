def isprime(x : UInt64)
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
    lim = (Math.sqrt(x) + 1.0).to_u64
    y = 3
    while y <= lim
        if x % y == 0
            return 0
        end
        y += 2
    end
    return 1
end

def genprime(max : UInt64)
    count = 0_u64
    current = 1_u64
    while count < max
        if isprime(current) != 0
            count += 1
        end
        current += 1
    end
    return current - 1
end

start = ARGV[0].to_u64
stop = ARGV[1].to_u64 + 1
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
