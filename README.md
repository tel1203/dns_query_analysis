# dns_query_analysis
Research for malicious behavior detection from DNS query traffic

## Usage: ex_tcpdump_parsecount.rb

This file shows analyzing example of text output from tcpdump.
It tries to parse the output, then count the parsed data.
It periodically produces analyzing result on screen.

note:
Users should specify the option to enable tcpdump to produce its output directly to STDOUT.  In OSX, the option is "-l".
Users must specify target network interface. It is presented as "NIF" below.

----
sudo tcpdump -n -l -i NIF | ruby ex_tcpdump_parsecount.rb
----

