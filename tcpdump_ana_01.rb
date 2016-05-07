list_src = Array.new
success = Hash.new(0)
failure = Hash.new(0)

period=1
last_timeslot = Time.now.to_i/period

printf("  %s\t     %s\t\t\t\t   %s   %s   %s  %s   %s\t\n","Time","Source IP","Total packet","Success packet","Success Rate %", "Failed packet", "Failed Rate %")

while (line=STDIN.gets) do

	period_timeslot = Time.now.to_i/period
  	data = line.strip.split(" ")
  	
  	time = data[0].split(".")[0,1].join(".")
  	
  	if (data[5][-1,1] == "\+" ) then
  		src = data[2].split(".")[0,4].join(".")
  	end
  	
  # recording src address
  	list_src.push(src)

  # count
  
	if (data[5][-1,1] != "\+" ) then
    	if(data[6][0,1] != "0" && data[6][0,1] != "N") then
        	success[src]  += 1
        else
			failure[src] += 1
        end 
    end
	

end

# output
success.keys.each do |src|
	
	count_query = success[src] + failure[src]	
	s_rate = success[src] * 100 /count_query
	f_rate = failure[src] * 100 /count_query 
	
	print time,"  ", src, "                                   ", count_query,"               ", success[src], "               ",s_rate, "             ", failure[src], "             ", f_rate
  	puts()

end