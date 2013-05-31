require 'spec_helper'

describe RRList::Functions do

  context ".calc_average" do
    it "should agregate" do
      RRList::Functions.calc_average(3,(2+3+4)/3,7).should eq ((2+3+4+7)/4)
      RRList::Functions.calc_average(3,(2+3+4)/3.0,(7+4)/2.0,2).should eq ((2+3+4+7+4)/5.0)
      RRList::Functions.calc_average(5,2,7,5).should eq 4.5
    end
  end

  it { RRList::Functions.avg.should be_a(Proc) }
  it { RRList::Functions.incr.should be_a(Proc) }
  it { RRList::Functions.decr.should be_a(Proc) }
  it { RRList::Functions.min.should be_a(Proc) }
  it { RRList::Functions.max.should be_a(Proc) }

end