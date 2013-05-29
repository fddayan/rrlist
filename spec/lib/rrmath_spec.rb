require 'spec_helper'

describe RRList::Functions do

  context ".average" do
    it "should agregate" do
      RRList::Functions.average(3,(2+3+4)/3,7).should eq ((2+3+4+7)/4)
      RRList::Functions.average(3,(2+3+4)/3.0,(7+4)/2.0,2).should eq ((2+3+4+7+4)/5.0)
      RRList::Functions.average(5,2,7,5).should eq 4.5
    end
  end

  it ".get_function_proc should return a proc" do
    RRList::Functions::FUNCTIONS_PROC.should_not be_empty

    RRList::Functions::FUNCTIONS_PROC.each do |k,v|
      RRList::Functions.get_function_prod(k).should be_a(Proc)
    end
  end
end