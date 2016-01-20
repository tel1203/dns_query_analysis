STDOUT.sync=true

count_query = Hash.new
list_query = Hash.new

# Trap break signal (CTRL+C) for output result
Signal.trap(:INT) {
  p count_query
  p list_query
}

def output_result()
end

# Period in sec for result output
period=10
last_timeslot = Time.now.to_i/period
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
    	#if (data[7] =~ /[0-9]+\/[0-9]+\//) then
      	list_query[src][data[7]] = 0
      	#end
    end
    list_query[src][data[7]] += 1
  end
  #
  if (data[6] =~ /[0-9]+\/[0-9]+\//) then
  	mask = data[7]
  	
  #if (data[6] =~ /[0-9]/) then 
#p line
  end

  # Check timeslot for controlling output timing
  # Output analyzing result in each timeslot, specified by "period".
  if (period_timeslot != last_timeslot) then
    #p list_query
    #p count_query
  	print time, count_query, dst, mask
  	p ""
  end
  last_timeslot = period_timeslot
  	
end

