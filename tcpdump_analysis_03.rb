#
# $ tcpdump -nltt -i en0 port 53 | ruby tcpdump_analysis_03.rb
#

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
  time = data[0].split(".")[0,1]
  src_ip   = data[2].split(".")[0,4]
  src_port = data[2].split(".")[4]
  dst_ip   = data[4].split(".")[0,4]
  dst_port = data[4].split(".")[4]
  queryid = data[5]
p data
p queryid

  #
#  if (queryid.index("+")>0) then
#    p line
#  end


  # Check timeslot for controlling output timing
  # Output analyzing result in each timeslot, specified by "period".
  if (period_timeslot != last_timeslot) then
  end
  last_timeslot = period_timeslot
end

