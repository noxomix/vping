module main

import hall_of_code.vping

fn main() {
	answ := vping.ping(ip: "ipv6.google.com", force: 6, timeout: 10)
	if answ.status == 0 {
		println(answ.parsed.avg.str()) //print the average time it took
	} else if answ.status == 1 {
		println("Packet Loss: " + answ.parsed.pk_loss_percent.str() + "%") //print the Packet Loss in %
	} else {
		println("Error: Status-Code = " + answ.status.str()) //print the Status Code
		println(answ.raw) //print out ping response from terminal as string
	}
}