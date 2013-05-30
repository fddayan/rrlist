require File.expand_path('../../lib/rrlist', __FILE__)

rrlists = []

fun = RRList::Functions.avg

rrlists << RRList::List.new(:size => 10, :range => 60, &fun)         # hours
rrlists << RRList::List.new(:size => 10, :range => 60*24, &fun)      # days
rrlists << RRList::List.new(:size => 10, :range => 60*24*7, &fun)    # weeks
rrlists << RRList::List.new(:size => 10, :range => 60*24*7*4, &fun)  # months

def add(rrlists, index, value)
  rrlists.each do |rrlist|
    rrlist.add_at index, value
  end
end

0.upto((60*24*7*4)*2) do |v|
  add(rrlists,v,v)
end

rrlists.each do |rrlist|
  puts "#{rrlist.values.collect {|v| v && v[:value]}}"
end
