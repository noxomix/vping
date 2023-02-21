module main

import hall_of_code.vping

fn main() {
	println("[ Start Test ] =>")
	basic_test()
	answer_visualize_test()
	force_test()
	conf_test()
	println("[ End Test ]")
}

fn basic_test()
{
	println("----- Basic Test: Start -----")
	result := vping.ping(ip: "google.com") //returns an vping.Answer Object
	println(result.parsed.mam_line) // "min/avg/max/mdev = 16.865/17.175/17.436/0.248 ms"
	println("The AVG Ping after ${result.parsed.pk_send} packages send, was ${result.parsed.avg}ms!")
	println("----- Basic Test: End -----")
}

fn answer_visualize_test()
{
	println("----- Answer Visu Test: Start -----")
	answ := vping.ping(ip: "google.com", timeout: 5, count: 2).no_newline_raw()
	println(answ.raw)
	println("----- Answer Visu: End -----")
}

fn force_test()
{
	println("----- Force Test: Start -----")
	answ := vping.ping(ip: "ipv6.google.com", force: 6, timeout: 10)
	if answ.status == 0 {
		println(answ.parsed.avg.str()) //print the average time it took
	} else if answ.status == 1 {
		println("Packet Loss: " + answ.parsed.pk_loss_percent.str() + "%") //print the Packet Loss in %
	} else {
		println("Error: Status-Code = " + answ.status.str()) //print the Status Code
		println(answ.raw) //print out ping response from terminal as string
	}
	println("----- Force Test: End -----")
}

fn conf_test()
{
	println("----- Conf Test: Start -----")
	params := vping.Conf{
		ip: "google.de"
		count: 6
		timeout: 10
		interval: 2
	}

	println(vping.ping(params))
	println("----- Conf Test: End -----")
}