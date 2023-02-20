# `vping` for Vlang
This is a Ping Library for the Vlang Programming-Language (Link: [vlang/v](https://github.com/vlang/v)).
`vping`  uses the "native" `ping` command of Linux and Windows (!Currently <ins>not</ins> well tested on Windows, and not compatible with MacOS. Tested on Ubuntu 20 based system).

#### (!) Project in early stage of Development - use it with care. Best Regards ~Theo.

## Quick Documentation
### Install it:
To install I'll recommend using `vpm`. Just use `v install <libname>` to install it.
The dependencies are `(Builtin) os` and `pcre`-regex.
After installation, you can simply use it by `import vping`.
### Basic Usage:

```vlang
module main 
    
import vping

fn main() {
    result := vping.ping(ip: "google.com") //returns an vping.Answer Object
    println(result.parsed.mam_line) // "min/avg/max/mdev = 16.865/17.175/17.436/0.248 ms"
    println("The AVG Ping after ${result.parsed.pk_send} packages send, was ${result.parsed.avg}ms!")
}
```
