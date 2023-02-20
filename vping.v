module vping

import os

// ping () -> runs the ping process and returns an <Answer> Object (Struct)
pub fn ping(pingconf Conf) Answer
{
	result := prepare(pingconf).join(" ")
	executed := os.execute(result)
	//println("CODE -> " + executed.exit_code.str()) // [0 -> Funzt, 1 -> Packet Loss, 2 -> Domain or name not found]
	return answer(executed, pingconf, result)
}

// answer () -> helper function to generate the <Answer> Object
pub fn answer(executed os.Result, pingconf Conf, cmd string) Answer
{
	return Answer{
		conf: pingconf
		command: cmd
		status: executed.exit_code
		raw: executed.output
		parsed: parse(executed.output)
	}
}

// prepare () -> Generate the command as an array | example: ["ping", "host.ip", "-c", "1"]
fn prepare(pingconf Conf) []string
{
	mut bmap := map[string]string{}
	$if windows {
		bmap = windows_map.clone()
	}
	$if linux {
		bmap = linux_map.clone()
	}
	mut result := ["ping", pingconf.ip]

	if pingconf.count > 0
	{
		result << bmap["count"]
		result << pingconf.count.str()
	}
	if pingconf.timeout > 0
	{
		result << bmap["timeout"]
		result << pingconf.timeout.str()
	}
	if pingconf.size > 0
	{
		result << bmap["size"]
		result << pingconf.size.str()
	}
	if pingconf.force in [4,6]
	{
		//in this case the argument itself is the argument, which means we hat to implement a replace
		result << bmap["force"].replace("$", pingconf.force.str())
	}
	if pingconf.ttl > 0
	{
		result << bmap["ttl"]
		result << pingconf.ttl.str()
	}
	//linux only:
	$if linux {
		if pingconf.iface != ""
		{
			result << bmap["iface"]
			result << pingconf.iface
		}
		if pingconf.interval > 0
		{
			result << bmap["interval"]
			result << pingconf.interval.str()
		}
	}
	//custom string | !! Security relevance !!:
	if pingconf.custom != ""
	{
		result << pingconf.custom
	}

	return result
}
