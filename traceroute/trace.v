module traceroute

import os

pub fn traceroute(params Parameter) SumAnswer
{
	//mut conf := TraceConfLinux{ip: "google.de", force: 4} //debug
	trace_arr := prepare(params.conf)
	command := trace_arr.join(" ")
	result := os.execute(command)
	if params.abstract == true {
		return AbstractTraceAnswer{
			command: command
			conf: params.conf
			os_result: result
		}
	}
	//parser is missing yet
	return ParsedTraceAnswer{
		command: command
		conf: params.conf
		os_result: result
		raw: result.output
	}
}

pub fn prepare(conf TraceConf) []string //sm type
{
	mut result := []string{}
	trace_set := prep_reference()
	map_conf := prep_conf(conf)
	for key, value in map_conf {
		if value in ["-1", "-1.0", "", "false"] {
			continue
		}
		if (*trace_set)[key].contains("$") {
			result << (*trace_set)[key].replace("$", value)
		} else if (*trace_set)[key].contains("%") {
			result << (*trace_set)[key].replace("%", "")
		} else {
			result << (*trace_set)[key]
			result << value
		}
	}
	return result
}

fn prep_reference() &map[string]string
{
	$if windows {
		return &trace_set_win
	}
	$if linux {
		return &trace_set_linux
	}
	return &trace_set_linux
}

fn prep_conf(conf TraceConf) map[string]string
{
	mut struct_to_map_help := map[string]string{}
	$if windows {
		nconf := conf as TraceConfWin
		$for field in TraceConfWin.fields {
			struct_to_map_help[field.name] = nconf.$(field.name).str()
		}
	}
	$if linux {
		nconf := conf as TraceConfLinux
		$for field in TraceConfLinux.fields {
			struct_to_map_help[field.name] = nconf.$(field.name).str()
		}
	}
	return struct_to_map_help
}

pub fn is_windows() bool
{
	$if windows {
		return true
	}
	return false
}