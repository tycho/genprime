use "collections"
use "time"

actor Main
  var _env: Env

  fun isPrime(x: U64): Bool =>
    var lim: U64
    if (x < 2) then
      return false
    end
    if (x == 2) then
      return true
    end
    if ((x % 2) == 0) then
      return false
    end
    if (x < 9) then
      return true
    end
    if (((x + 1) % 6) != 0) then
      if (((x - 1) % 6) != 0) then
        return false
      end
    end
    lim = (x.f64().sqrt() + 1.0).u64()
    for y in Range[U64](3, lim, 2) do
      if ((x % y) == 0) then
        return false
      end
    end
    true

    fun genprime(max: U64): U64 =>
      var count: U64 = 0
      var current: U64 = 1
      while count < max do
        if isPrime(current) then
          count = count + 1
        end
        current = current + 1
      end
      current - 1

  new create(env: Env) =>
    _env = env

    let start: U32 = try env.args(1).u32() else 25000 end
    let stop: U32 = try env.args(2).u32() else 100000 end

    var startTime: (I64, I64)
    var endTime: (I64, I64)

    for i in Range[U32](start, stop + 1, start) do
      startTime = Time.now()
      let last = genprime(i.u64())
      endTime = Time.now()
      let duration = (endTime._1 - startTime._1, endTime._2 - startTime._2)
      let seconds: F64 = duration._1.f64() + (duration._2.f64() / 1000000000.0)
      env.out.print(
        "Found " + i.string() + " primes in "
          + seconds.string() + " seconds "
          + " (last was " + last.string() + ")"
      )
    end
