# `vping` for Vlang
This is a Ping Library for the Vlang Programming-Language (Link: [vlang/v](https://github.com/vlang/v)).
`vping`  uses the "native" `ping` command of Linux and Windows (!Currently <ins>not</ins> well tested on Windows, and not compatible with MacOS. Tested on Ubuntu 20 based system).

#### (!) Project in early stage of Development - use it with care. Best Regards ~Theo.

## Quick Documentation
### Install it:
To install I'll recommend using `vpm`. Just use `v install hall_of_code.vping` to install it.
The dependencies are `(Builtin) os` and `pcre`-regex.
After installation, you can simply use it by `import vping`.
### Basic Usage:

```vlang
module main 

import hall_of_code.vping

fn main() {
    result := vping.ping(ip: "google.com") //returns an vping.Answer Object
    println(result.parsed.mam_line) // "min/avg/max/mdev = 16.865/17.175/17.436/0.248 ms"
    println("The AVG Ping after ${result.parsed.pk_send} packages send, was ${result.parsed.avg}ms!")
}
```

#### Arguments:

| Argument | Description | Importance              | Example |
|----------|-------------|-------------------------|---------|
| `ip`       | The IP-Adress/Hostname/Domain of the Host                                                              | `required`              | `ping(ip: "google.com")`                           |
| `count`    | Number of Packets to send                                                                              | `(optional)`            | `ping(ip: "google.de", count: 4)`                  |
| `timeout`  | On Windows this is the time per Packet in MS - on Linux its for the whole Ping Process and in Seconds. | `(optional)`            | `ping(ip: "google.de", timeout: 10)`               |
| `size`     | Size per Packet to send in Byte                                                                        | `(optional)`            | `ping(ip: "google.de", size: 16)`                  |
| `force`    | Force to use IPv4 / IPv6                                                                               | `(optional)`            | `ping(ip: "google.de", force: 4) //forces to IPv4` |
| `ttl`      | Given TTL                                                                                              | `(optional)`            | `ping(ip: "google.de", ttl: 15)`                   |
| `iface`    | Network Interface Name (Linux-Only)                                                                    | `(optional/Linux-Only)` | `ping(ip: "google.de", iface: "eth0"`              |
| `interval` | Interval of packets in Seconds (Linux-Only)                                                            | `(optional/Linux-Only)` | `ping(ip: "google.de", interval: 1)`               |

