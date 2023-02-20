# `vping` for Vlang
This is a Ping Library for the Vlang Programming-Language (Link: [vlang/v](https://github.com/vlang/v)).
`vping`  uses the "native" `ping` command of Linux and Windows (!Currently <ins>not</ins> well tested on Windows, and not compatible with MacOS. Tested on Ubuntu 20 based system).

#### (!) Project in early stage of Development - use it with care. Best Regards ~Theo.

## Quick Documentation
### Install it:
To install I'll recommend using `vpm`. Just use `v install hall_of_code.vping` to install it.
The dependencies are `(Builtin) os` and `pcre`-regex.
After installation, you can simply use it by `import hall_of_code.vping`.
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

## Functions:
Only public functions are documented here :) `//everything else -> todo for later`
### `ping(Conf) Answer`
This function takes a Conf-Struct as Parameter - since this is comparable with "named arguments", you also can
do `ping(ip: "google.de", count: 2, timeout: 5)`.
The Command takes some time - (while running the Ping Process by os.execute) and then - returns an `Answer{}`
Struct/Object.

### `(Answer) no_newline_raw() Answer`
(Just for visualization-purpose).
This function is callable on Answer-Object, and returns a new Answer where `<Answer>.raw` all `\n` replaced by ` `. 
__Example:__
```vlang
module main

import hall_of_code.vping

fn main() {
    answ := vping.ping(ip: "google.com", timeout: 5, count: 2).no_newline_raw()
    println(answ.raw)
}
```

### `Answer{}`-Struct:
```vlang
pub struct Answer {
    mut:
        conf Conf      //given Conf (line {ip: "google.de", count: 3})
        command string //the generated ping-command
        status int     //status code (exit_status) -> 0 = everything ok, 1 = packetloss, 2 = ping-error
        raw string     //full terminal-response as string
        parsed Parsed  //parsed response, here it gets interesting ;)
}
```
### `Parsed{}`-Struct:
```vlang
pub struct Parsed {
	mut:
		time_tt int          //total time the answer took
		pk_send int          //number of packets send
		pk_recv int          //number of packets received
		pk_loss_percent int  //package loss in percent (%)
		mam_line string      //min/max/avg - line
		avg f32              //avg  (in ms)
		min f32              //min  (in ms)
		max f32              //max  (in ms)
		mdev f32             //mdev (in ms)
} 
```

## Further Examples:

Force to use IPv6 Ping:
```vlang
module main

import hall_of_code.vping

fn main() {
    answ := vping.ping(ip: "ipv6.google.com", force: 6, timeout: 10)
    if answ.status == 0 {
		println(answ.parsed.avg.str()) //print the average time it took
    } else if answ.status == 1 {
		println("Packet Loss: " + answ.parsed.pk_loss.str() + "%") //print the Packet Loss in %
    } else {
		println("Error: Status-Code = " + answ.status.str()) //print the Status Code
        println(answ.raw) //print out ping response from terminal as string
    }
}
```

Use Conf Struct as Parameter:
```vlang
module main

import hall_of_code.vping

fn main() {
    params := Conf{
        ip: "google.de"
        count: 6
        timeout: 10
        interval: 2
    }
    
    println(vping.ping(params))
}
```


