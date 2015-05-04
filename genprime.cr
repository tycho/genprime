def isprime(x : UInt64)
    if x < 2_u64
        return 0
    end
    if x == 2_u64
        return 1
    end
    if x % 2_u64 == 0_u64
        return 0
    end
    if x < 9_u64
        return 1
    end
    if (x + 1_u64) % 6_u64 != 0_u64
        if (x - 1_u64) % 6_u64 != 0_u64
            return 0
        end
    end
    lim = (Math.sqrt(x) + 1.0).to_u64
    y = 3_u64
    while y <= lim
        if x % y == 0_u64
            return 0
        end
        y += 2_u64
    end
    return 1
end

def genprime(max : UInt64)
    count = 0_u64
    current = 1_u64
    while count < max
        if isprime(current) != 0
            count += 1_u64
        end
        current += 1_u64
    end
    return current - 1_u64
end

start = ARGV[0].to_u64
stop = ARGV[1].to_u64 + 1_u64
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
