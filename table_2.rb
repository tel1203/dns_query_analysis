require 'benchmark'
list_src = Array.new
success = Hash.new(0)
failure = Hash.new(0)
s = Hash.new(0)
period=1
last_timeslot = Time.now.to_i/period

printf("  %s\t     %s\t\t\t\t   %s      \t\n","Time","target name","Total packet")

# The data contains tcpdump output as below.
  # Ex:
  # ["03:02:29.954497", "IP", "192.168.1.158.54397", ">", "210.130.1.1.53:", "11664+", "A?", "e6858.dscc.akamaiedge.net.0.1.cn.akamaiedge.net.", "(65)"]
  # ["03:02:29.985184", "IP", "210.130.1.1.53", ">", "192.168.1.158.54397:", "11664", "1/0/0", "A", "104.110.7.129", "(81)"]
  # 00:54:50.098109 IP 192.168.42.11.57843 > google-public-dns-a.google.com.domain: 52072+ A? asfasdgdfg.af. (31)
  # 00:54:50.181646 IP google-public-dns-a.google.com.domain > 192.168.42.11.57843: 52072 NXDomain 0/1/0 (99)
  
while (line=STDIN.gets) do

	period_timeslot = Time.now.to_i/period
  	data = line.strip.split(" ")
  	
  	time = data[0].split(".")[0,1].join(".")
  	
  	if (data[5][-1,1] == "\+" ) then
  		src = data[7]
  	end
  	
  # recording src address
  	list_src.push(src)

  # count
  
	if (data[5][-1,1] == "\+" ) then
    	if(data[6][0,1] != "0" && data[6][0,1] != "N") then
        	success[src]  += 1
        end 
    end
end

#output
success.keys.each do |src|
		print time,"  ", src, "                                   ", success[src]
		puts()
	end
