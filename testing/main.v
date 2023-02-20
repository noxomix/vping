module main

import hall_of_code.vping

fn main() {
answ := vping.ping(ip: "google.com", timeout: 5, count: 2).no_newline_raw()
println(answ.raw)
}