extern crate num;
extern crate time;

use std::env;

use num::iter;

fn isprime(x: u64) -> bool {
    let lim: u64;

    if x < 2 {
        return false;
    }
    if x == 2 {
        return true;
    }
    if x % 2 == 0 {
        return false;
    }
    if x < 9 {
        return true;
    }
    if (x + 1) % 6 != 0 {
        if (x - 1) % 6 != 0 {
            return false;
        }
    }
    lim = ((x as f64) + 1.0f64).sqrt() as u64;
    for y in iter::range_step_inclusive(3, lim, 2) {
        if x % y == 0 {
            return false;
        }
    }

    return true;
}

fn genprime(max: u64) -> u64 {
    let mut   count: u64 = 0;
    let mut current: u64 = 1;

    while count < max {
        if isprime(current) {
            count += 1;
        }
        current += 1;
    }

    return current - 1;
}

fn main() {
    let  args: Vec<String> = env::args().collect();
    let start: u64;
    let  stop: u64;
    let mut  last: u64;
    let mut begin: f64;
    let mut   end: f64;

    start = if args.len() > 1 {
        args[1].parse().unwrap()
    } else {
        0
    };

    stop = if args.len() > 2 {
        args[2].parse().unwrap()
    } else {
        0
    };

    for x in iter::range_step_inclusive(start, stop, start) {
        begin = time::precise_time_s();
        last = genprime(x);
        end = time::precise_time_s();
        println!("Found {:8} primes in {:10.5} seconds (last was {:10})", x, end - begin, last);
    }
}
