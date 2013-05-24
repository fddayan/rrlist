require 'spec_helper'
# require 'rrlist'

describe "do the hasel" do 
  it "should do the hasel" do
    # do_the_hasel((1..20).to_a.shuffle).should eq [5,10,15,20]
    do_the_hasel((1..20)).should eq [5,10,15,20]
  end
end

def do_the_hasel(args)
  rr_list = RRList.new :size => 10 ,:range => 5
  
  rr_list.before_add &RRMath.max
  
  args.each_with_index do |v,i|
    rr_list.add(v)
  end
  
  rr_list.values.compact
end