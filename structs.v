module vping

[params]
pub struct Conf {
	mut:
		ip string
		count int     = 4
		timeout int   = -1
		size int      = -1
		force int     = -1
		iface string         //linux only
		ttl int       = -1	 //time to live
		interval int  = -1   //interval in seconds between packages
		custom string        //no osmapping since this is raw | !! security relevance !!
}

pub struct Answer {
	pub mut:
		conf Conf //given Conf
		command string //given command
		status int //response status
		raw string //full response of ping command
		parsed Parsed //partly parsed response
}


// no_newline_raw -> This function replaces all \n in the raw field of answer with a space, its just for visualization purpose
pub fn (answer Answer) no_newline_raw() Answer
{
	mut rs := answer
	rs.raw = answer.raw.replace("\n", " ")
	return rs
}

pub struct Parsed {
	mut:
		time_tt int //in ms
		pk_send int //number of packages send
		pk_recv int //number of packages received
		pk_loss_percent int //package loss in percent%
		mam_line string //min/max/avg full line
		avg f32 //ms
		min f32 //ms
		max f32 //ms
		mdev f32 //ms
}