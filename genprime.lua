function isprime(x)
  if x < 2 then
	return false
  end
  if x < 4 then
    return true
  end
  if x == 5 then
    return true
  end
  if x % 2 == 0 then
    return false
  end
  if x % 5 == 0 then
    return false
  end
  if (x + 1) % 6 ~= 0 then
    if (x - 1) % 6 ~= 0 then
	  return false
	end
  end
  local lim = math.sqrt(x) + 1.0
  for y=3,lim,2 do
    if x % y == 0 then
	  return false
	end
  end
  return true
end

function genprime(mx)
  local count = 0
  local current = 1
  while count < mx do
    if isprime(current) then
	  count = count + 1
	end
	current = current + 1
  end
  return current - 1
end

function main(startN, endN)
  for x = startN, endN, startN do
    timeS = os.clock()
    lastN = genprime(x)
    timeE = os.clock()
	timeT = timeE - timeS
    io.write(string.format("Found %8d primes in %10.5f seconds (last was %10u)\n", x, timeT, lastN))
  end
end

main(arg[1],arg[2])
