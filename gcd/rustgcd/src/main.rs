extern crate num;
use num::Integer;
use std::f64;
use std::time::Instant;

fn calc_pi_by_gcd(n:i64)->f64 {
    let mut s=0;
    for a in 1..n+1 {
        for b in 1..n+1{
            if a.gcd(&b)==1{
                s+=1;
            }
        }
    }

    let pi = ((6*n*n) as f64/s as f64).sqrt();
    return pi;

}


fn main(){
    let n = 20000;
    let start = Instant::now();
    let pi = calc_pi_by_gcd(n);
    let end = start.elapsed();
    println!("Pi = {}",pi);
    println!(
        "Elapsed time = {}.{:03}",
        end.as_secs(),
        end.subsec_nanos() / 1_000_000
    );
}