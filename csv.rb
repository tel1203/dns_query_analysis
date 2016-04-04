STDOUT.sync=true


count_query = Hash.new
list_query = Hash.new
failed_packet = 0
success_packet = 0

def output_result()
end

# Period in sec for result output
period=60
last_timeslot = Time.now.to_i/period
printf("  %s\t\t   %s\t  %s\t%s\t\n\n","Time","Source IP","failed query","Destination")
while (line=STDIN.gets) do
  # The data contains tcpdump output as below.
  # Ex:
  # ["03:02:29.954497", "IP", "192.168.1.158.54397", ">", "210.130.1.1.53:", "11664+", "A?", "e6858.dscc.akamaiedge.net.0.1.cn.akamaiedge.net.", "(65)"]
  # ["03:02:29.985184", "IP", "210.130.1.1.53", ">", "192.168.1.158.54397:", "11664", "1/0/0", "A", "104.110.7.129", "(81)"]

       period_timeslot = Time.now.to_i/period
        data = line.strip.split(" ")
		failed = data[7]
  
       if (failed != nil) && (data[5][-1,1] != "\+") then
           if(failed[0,1] != "0") then
           success_packet  += 1
           end 
       end
        #try to find the response query and then check is it failed or no
        if (failed != nil) && (data[5][-1,1] != "\+") then
           	if(failed[0,1] == "0") then
           		failed_packet  += 1
           	end 
          
    	end 
  #
        if (data[6] =~ /[0-9]+\/[0-9]+\//) then
                mask = data[7]
        end
 
        if (period_timeslot != last_timeslot) then
        	print  data[0], ("   "), success_packet,(",  "), failed_packet 
            
           open('myfile.csv', 'a+') { |f|
  				f.print data[0][3,2], (",  "),success_packet, (",  ")
  				f.puts failed_packet
  				}
			
            puts()
            failed_packet = 0
            success_packet = 0
        end
           last_timeslot = period_timeslot        
end	