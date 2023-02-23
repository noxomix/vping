module traceroute

import os

const(
	trace_set_win = {
		"main":  "$" //itself
		"ip": "$" //itself
		"no_hostname": "%-d"
		"max_hops": "-h"
		"time_limit": "-w"
		"force": "-$" //itself
		"loose_source_route": "-j" //v4 only
		"flat_path": "-R"   //rundwegpfad v6 only
		"source_addr": "-S" //Quelladresse v6 only
	}

	trace_set_linux = {
		"main": "$" //itself
		"ip": "$" //itself
		"force" : "-$" //itself
		"no_hostname": "%-n" //Do not resolve IP addresses to their domain names
		//linux only:
		"socket_debug": "%-d" //Enable socket level debugging
		"no_fragment" : "%-F" //Do not fragment packets
		"first_ttl"   : "-f" //Start from the first_ttl hop (instead from 1)
		"max_ttl"     : "-m" //Set the max number of hops (max TTL to be reached). Default is 30
		"gateway"     : "-g" //Route packets through the specified gateway (maximum 8 for IPv4 and 127 for IPv6)
		"icmp_echo"   : "%-I" //Use ICMP ECHO for Traceroute
		"tcp_syn"     : "%-T" //Use TCP SYN for tracerouting (default port is 80)
		"iface"       : "-i" //Specify a network interface to operate with
		"squeries"    : "-N" //Set the number of probes to be tried simultaneously (default is 16)
		"port"        : "-p" //Set the destination port to use. It is either initial udp port value for "default" method (incremented by each probe, default is 33434), or initial seq for "icmp" (incremented as well, default from 1), or some constant destination port for other methods (with default of 80 for "tcp", 53 for "udp", etc.)
		"tos"         : "-t" //Set the TOS (IPv4 type of service) or TC (IPv6 traffic class) value for outgoing packets
		"probe_wait"  : "-w" /*Wait for a probe no more than HERE (default 3)times longer than a response from the same hop,or no more than NEAR (default 10) times than some next hop, or MAX (default 5.0) seconds (floatpoint values allowed too)*/
		"query_number" : "-q" //Set the number of probes per each hop. Default is 3.
		"bypass"      : "%-r" //Bypass the normal routing and send directly to a host on an attached network
		"src_addr"    : "-s" //Use source src_addr for outgoing packets
		"sendwait"    : "-z" //Minimal time interval between probes (default 0).
		"extensions"  : "%-e" //Show ICMP extensions (if present), including MPLS
		"as_path"     : "%-A" //Perform AS path lookups in routing registries and print results directly after the corresponding addresses
		"mod_spec"    : "-M" //Use specified module (either builtin or external) for traceroute operations.
		"opts"        : "-O" //Use module-specific option OPTS for the traceroute module.
		"sport"       : "--sport=$"  //Use source port num for outgoing packets. Implies `-N 1'.
		"fw_mark"     : "--fwmark=$" //Set firewall mark for outgoing packets.
		"udp"         : "%-U"       // Use UDP to particular port for tracerouting (instead of increasing the port per each probe), default port is 53
		"ul"          : "%-UL"      //Use UDPLITE for tracerouting (default dest port is 53)
		"dccp"        :  "%-D"       //Use DCCP Request for tracerouting (default port is 33434)
		"prot"        : "-P"       //Use raw packet of protocol prot for tracerouting
		"mtu"         : "%--mtu"    //Discover MTU along the path being traced. Implies `-F -N 1'.
		"back"        : "%--back"   //Guess the number of hops in the backward path and print if it differs.
		"version"     : "%-V"       //Print version info and exit.
		"flow_label string": "-l" //Use specified flow_label for IPv6 packets. v6 only
	}
)
[params]
type TraceConf = TraceConfLinux | TraceConfWin
type SumAnswer = AbstractTraceAnswer | ParsedTraceAnswer
[params]
pub struct TraceConfWin {
	pub mut:
		main string = "tracert"
		ip string
		no_hostname bool
		max_hops int = -1
		time_limit int = -1
		force int = -1 //itself
		loose_source_route string //v4 only
		flat_path string  //rundwegpfad v6 only
		source_addr string //Quelladresse v6 only
}
[params]
pub struct TraceConfLinux {
	pub mut:
		main         string = "traceroute"
		ip 			 string
		force        int = -1 //itself
		no_hostname  bool //Do not resolve IP addresses to their domain names
		//linux only:
		socket_debug bool //Enable socket level debugging
		no_fragment  bool //Do not fragment packets
		first_ttl    int = -1 //Start from the first_ttl hop (instead from 1)
		max_ttl      int = -1 //Set the max number of hops (max TTL to be reached). Default is 30
		gateway      int = -1 //Route packets through the specified gateway (maximum 8 for IPv4 and 127 for IPv6)
		icmp_echo    bool //Use ICMP ECHO for Traceroute
		tcp_syn      bool //Use TCP SYN for tracerouting (default port is 80)
		iface        string //Specify a network interface to operate with
		squeries     int = -1 //Set the number of probes to be tried simultaneously (default is 16)
		port         int = -1 //Set the destination port to use. It is either initial udp port value for "default" method (incremented by each probe, default is 33434), or initial seq for "icmp" (incremented as well, default from 1), or some constant destination port for other methods (with default of 80 for "tcp", 53 for "udp", etc.)
		tos          string //Set the TOS (IPv4 type of service) or TC (IPv6 traffic class) value for outgoing packets
		probe_wait   int = -1 /*Wait for a probe no more than HERE (default 3)times longer than a response from the same hop,or no more than NEAR (default 10) times than some next hop, or MAX (default 5.0) seconds (floatpoint values allowed too)*/
		query_number int = -1 //Set the number of probes per each hop. Default is 3.
		bypass       bool   //Bypass the normal routing and send directly to a host on an attached network
		src_addr     string   //Use source src_addr for outgoing packets
		sendwait     int = -1  //Minimal time interval between probes (default 0).
		extensions   bool   //Show ICMP extensions (if present), including MPLS
		as_path      bool   //Perform AS path lookups in routing registries and print results directly after the corresponding addresses
		mod_spec     string //Use specified module (either builtin or external) for traceroute operations.
		opts         string   //Use module-specific option OPTS for the traceroute module.
		sport        string  //Use source port num for outgoing packets. Implies `-N 1'.
		fw_mark      string //Set firewall mark for outgoing packets.
		udp          bool   // Use UDP to particular port for tracerouting (instead of increasing the port per each probe), default port is 53
		ul           bool      //Use UDPLITE for tracerouting (default dest port is 53)
		dccp         bool       //Use DCCP Request for tracerouting (default port is 33434)
		prot         string       //Use raw packet of protocol prot for tracerouting
		mtu          bool    //Discover MTU along the path being traced. Implies `-F -N 1'.
		back         bool   //Guess the number of hops in the backward path and print if it differs.
		version      bool     //Print version info and exit.
		flow_label string     //Use specified flow_label for IPv6 packets. v6 only
}

[params]
pub struct Parameter {
	pub mut:
		conf TraceConf [required]
		custom string
		abstract bool
}

//return
pub struct AbstractTraceAnswer {
	pub:
		conf TraceConf
		command string
		os_result os.Result
}

pub struct ParsedTraceAnswer {
	pub:
		conf TraceConf
		command string
		os_result os.Result
		raw string
} //todo: change this and build a parser
