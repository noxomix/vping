# `vping.Traceroute` Documentation
__Traceroute is part of vping and don't need to be installed separately. So
feel free to import it with:__
```vlang
import vping.traceroute
```

vping.Traceroute uses the native `tracert` command on windows, and the `traceroute`
command on linux - __Which had eventually to be installed via:__
```sh
sudo apt-get install traceroute
```
Please note the Platforms are completely different from each other, and you need to give
a different Config Struct to the function on windows and on linux.

## Basic Usage:
```vlang
module main

import hall_of_code.vping.traceroute

fn main() {
	x := traceroute.traceroute(conf: traceroute.TraceConfLinux{ip: "google.de"}) as traceroute.ParsedTraceAnswer

	println(x.os_result.output)
}
```
And yes - this might be look a little different from the normal `vping` structure. Wait, I'll explain
it to you:
```
vping.traceroute takes advantage of SumTypes - which basically means that the traceroute(<PARAMETER>) function
can return two different Objects (Structs). You can return an AbstractTraceAnswer Struct or a ParsedTraceAnswer Struct.
Both for different cases - thats why you had to cast them with the "as traceroute.ParsedTraceAnswer" syntax.
```
But we also have this _weird looking_ `traceroute.TraceConfLinux{}` parameter. Which should be used on Linux machines,
as well as `traceroute.TraceConfWin{}` for Windows runtimes.

__If you want to build a software which runs on Linux and Windows the same, you can use this example:__

```vlang
module main

import hall_of_code.vping.traceroute
import vping.traceroute


fn main() {
    mut params := Parameter{abstract: true} //then the traceroute() returns a AbstractTraceAnswer Object
	if traceroute.is_windows() == true {
		params.conf = traceroute.TraceConfWin{ip: "google.com"}
	} else {
		arams.conf = traceroute.TraceConfLinux{ip: "google.com"}
    }
	result := traceroute.traceroute(conf: params) as traceroute.AbstractTraceAnswer
    println(result)
}
```

## Structs
I just paste the raw config structs here:

That's all the possible Arguments for Linux:
```vlang
pub struct TraceConfLinux {
	pub mut:
		main         string = "traceroute" //better dont change
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
```

And here the shorty, the Windows Struct:
```vlang
pub struct TraceConfWin {
	pub mut:
		main string = "tracert" //better dont change
		ip string
		no_hostname bool
		max_hops int = -1
		time_limit int = -1
		force int = -1 //itself
		loose_source_route string //v4 only
		flat_path string  //rundwegpfad v6 only
		source_addr string //Quelladresse v6 only
}
```

//this docs need to be completed