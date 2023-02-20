module main

import hall_of_code.vping

fn main() {
	params := vping.Conf{
		ip: "google.de"
		count: 6
		timeout: 10
		interval: 2
	}

	println(vping.ping(params))
}