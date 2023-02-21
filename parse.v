module vping

import pcre

// parse | Linux only
fn parse(output string) Parsed
{
	mut parsed := Parsed{}
	parsed.pk_send = r_match("([0-9]+) packets transmitted", output).int() //packets send
	parsed.pk_recv = r_match("([0-9]+) received,", output).int() //packets received
	parsed.pk_loss_percent = r_match("([0-9]+)% packet loss,", output).int() //packet loss in percent
	parsed.time_tt = r_match(", time ([0-9]+)ms", output).int() //total time
	parsed.mam_line = r_match("rtt (.+)", output) //min/max/avg string line
	p_mam_f := parsed.mam_line.split("v = ")
	if p_mam_f.len > 1
	{
		p_mam_s := p_mam_f[1].split("/")
		if p_mam_s.len > 3 && p_mam_s.len < 5
		{
			parsed.min = p_mam_s[0].f32() //min
			parsed.avg = p_mam_s[1].f32() //avg
			parsed.max = p_mam_s[2].f32() //max
			p_mam_t := p_mam_s[3].split(" ms")
			parsed.mdev = p_mam_t[0].f32() //mdev in ms
		}
	}
	if parsed == Parsed{} //if nothing changed, nothing parsed = return Parsing Error
	{
		parsed.is_err = 1
	}
	return parsed
}

fn r_match(rex string, str string) string
{
	r := pcre.new_regex(rex, 0) or {
		return "-1"
	}
	m := r.match_str(str, 0, 0) or {
		//println('[Parser] No match!')
		return "-1"
	}

	matched_str := m.get(1) or {
		//println('We matched nothing...')
		return "-1"
	}
	r.free()
	return matched_str
}