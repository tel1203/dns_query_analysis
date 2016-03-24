STDOUT.sync=true

count_query = Hash.new
list_query = Hash.new
values = Hash.new
packet = 0
src = Hash.new
dst = Hash.new
time = Hash.new

def output_result()
end

# Period in sec for result output
period=10
last_timeslot = Time.now.to_i/period
printf("  %s\t\t   %s\t  %s\t%s\t\n\n","Time","Source IP","failed query","Destination")
while (line=STDIN.gets) do
  # The data contains tcpdump output as below.
  # Ex:
  # ["03:02:29.954497", "IP", "192.168.1.158.54397", ">", "210.130.1.1.53:", "11664+", "A?", "e6858.dscc.akamaiedge.net.0.1.cn.akamaiedge.net.", "(65)"]
  # ["03:02:29.985184", "IP", "210.130.1.1.53", ">", "192.168.1.158.54397:", "11664", "1/0/0", "A", "104.110.7.129", "(81)"]

       period_timeslot = Time.now.to_i/period
        data = line.strip.split(" ")
        #src = data[2].split(".")[0,4]
        #dst = data[4].split(".")[0,4]
        #time = data[0].split(".")[0,1]
        #failed = data[7].split(".")[0,1]
		failed = data[7]
	
		
        
	
  # Pickup DNS query
  #  if (data[7] == "A?") then

    # Initialize, variable preparation for 1st query
    	if (count_query[src] == nil) then
        	count_query[src] = 0
        end
            count_query[src] += 1
       
        if (failed != nil) && (data[5][-1,1] != "\+") then
           if(failed[0,1] == "0") then
           packet  += 1
           end 
          	src = data[4].split(".")[0,4]
        	dst = data[2].split(".")[0,4]
        	time = data[0].split(".")[0,1]
    	end
		#elsif (failed_query[failed] == nil) then
         #   failed_query[failed] = 0
        #end
                
  #
        if (data[6] =~ /[0-9]+\/[0-9]+\//) then
                mask = data[7]
        end
  #  end
		
	#	s = count_query.split(",")[0]
	#	c = count.split(",")[1]
	#	p s
	#	p c
  # Check timeslot for controlling output timing
  # Output analyzing result in each timeslot, specified by "period".
        if (period_timeslot != last_timeslot) then
           #     print count_query
           #     p count
        	print time,src, packet, dst
            #p packet
            puts()
            packet = 0
        end
        last_timeslot = period_timeslot
         
end
