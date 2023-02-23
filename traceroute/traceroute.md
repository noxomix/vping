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

import vping.traceroute

x := traceroute.traceroute(conf: traceroute.TraceConfLinux{ip: "google.de"}) as traceroute.ParsedTraceAnswer

println(x.raw)
```