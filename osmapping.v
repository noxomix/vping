module vping

const(
	windows_map = {
		"count": "-n"
		"timeout": "-w" //in windows per sendet package not for all, in ms
		"size": "-l"
		"force": "-$"
		"ttl": "-i"
	}
	linux_map = {
		"count": "-c"
		"timeout": "-W"
		"size": "-s"
		"force": "-$"
		"iface": "-I" //uppercase i | Linux Only
		"ttl": "-t"
		"interval": "-i" //lowercase i | Linux only
	}
)