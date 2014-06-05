import Foundation

func isprime(x: Int) -> Bool {
    var lim: Int
    var y: Int
    if (x < 2) {
        return false
    }
    if (x == 2) {
        return true
    }
    if (x % 2 == 0) {
        return false
    }
    if (x < 9) {
        return true
    }
    if ((x + 1) % 6 != 0) {
        if ((x - 1) % 6 != 0) {
            return false
        }
    }
    lim = Int(sqrt(Double(x)) + 1.0)
    for (y = 3; y < lim; y += 2) {
        if (x % y == 0) {
            return false
        }
    }
    return true
}

func genprime(max: Int) -> Int {
    var count = 0
    var current = 1
    while (count < max) {
        if (isprime(current)) {
            count += 1
        }
        current += 1
    }
    return current - 1
}

var start: Int = 0
var stop: Int = 0

let startArg = String.fromCString(C_ARGV[1])
let stopArg = String.fromCString(C_ARGV[2])

if (Int(C_ARGC) > 1) {
    if let n = startArg.toInt() {
        start = n
    }
}

if (Int(C_ARGC) > 2) {
    if let n = stopArg.toInt() {
        stop = n + 1
    }
}

var x: Int
var last: Int

var begin: timeval = timeval(tv_sec: 0, tv_usec: 0)
var end: timeval = timeval(tv_sec: 0, tv_usec: 0)
var duration: Double

for (x = start; x < stop; x += start) {
    gettimeofday(&begin, nil)
    last = genprime(x)
    gettimeofday(&end, nil)
    duration = Double(end.tv_sec - begin.tv_sec) + (Double(end.tv_usec) - Double(begin.tv_usec)) / 1000000.0
    println("Found\t\(x) primes in\t\(duration) seconds (last was \t\(last))")
}
