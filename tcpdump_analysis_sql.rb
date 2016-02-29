#!/usr/bin/ruby

require 'rubygems' 
require 'gnuplot.rb'
require 'mysql'

STDOUT.sync=true
count_query = Hash.new
list_query = Hash.new
t = Hash.new
c = Hash.new
s = Hash.new
# Trap break signal (CTRL+C) for output result
Signal.trap(:INT) {
  p count_query
  p list_query
	}
def output_result()
end

# Period in sec for result output
period=60
last_timeslot = Time.now.to_i/period
printf("  %s\t\t   %s\t    %s\t%s\t  %s\t\n","Time","Source IP","Count","Destination", "Query type")
while (line=STDIN.gets) do
  # The data contains tcpdump output as below.
  # Ex:
  # ["03:02:29.954497", "IP", "192.168.1.158.54397", ">", "210.130.1.1.53:", "11664+", "A?", "e6858.dscc.akamaiedge.net.0.1.cn.akamaiedge.net.", "(65)"]
  # ["03:02:29.985184", "IP", "210.130.1.1.53", ">", "192.168.1.158.54397:", "11664", "1/0/0", "A", "104.110.7.129", "(81)"]

	period_timeslot = Time.now.to_i/period
	data = line.strip.split(" ")
	src = data[2].split(".")[0,4]
 
	time = data[0].split(".")[0,1]
  
  # Pickup DNS query
  	if (data[6] == "A?") then
  	 	dst = data[4].split(".")[0,4]
    # Initialize, variable preparation for 1st query
		if (count_query[src] == nil) then
      		count_query[src] = 0
    	end
    		count_query[src] += 1

    # Initialize, Hash data preparation for 1st query
    	if (list_query[src] == nil) then
      		list_query[src] = Hash.new
    	end
    # Initialize, variable data preparation for 1st query
    	if (list_query[src][data[7]] == nil) then
      		list_query[src][data[7]] = 0
    	end
    	list_query[src][data[7]] += 1
	end
  # print just totle packet not all info

	if (data[6] =~ /[0-9]+\/[0-9]+\//) then
  		mask = data[7]
  	end
  	
	count_query.each do |number|
    		c = number[1]
    		s = number[0]
			end
		#split the time to get just minute
    	time.each do |num|
    		t = num[1, 7]
			end
	
	
	if (period_timeslot != last_timeslot) then
    			
  		print time, s, c, dst, mask
  		puts()
  		begin
    		con = Mysql.new 'localhost', 'andisha', 'bbc',  'mydb'

    		rs = con.query("INSERT INTO monitoring (t, total, Source, Destination, Query_Type) VALUES('#{t}', '#{c}', '#{s}', '#{dst}',  '#{mask}')")
    		rescue Mysql::Error => e
    		puts e.errno
    		puts e.error
    
			ensure
    			con.close if con
			end
  	 	end
	

  last_timeslot = period_timeslot 	
end

