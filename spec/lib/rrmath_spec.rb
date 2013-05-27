require 'spec_helper'

describe RRMath do

  context ".average" do
    it "should agregate" do
      RRMath.average(3,(2+3+4)/3,7).should eq ((2+3+4+7)/4)
      RRMath.average(3,(2+3+4)/3.0,(7+4)/2.0,2).should eq ((2+3+4+7+4)/5.0)
      RRMath.average(5,2,7,5).should eq 4.5
    end
  end

  it ".get_function_proc should return a proc" do
    RRMath::FUNCTIONS_PROC.should_not be_empty

    RRMath::FUNCTIONS_PROC.each do |k,v|
      RRMath.get_function_prod(k).should be_a(Proc)
    end
  end
end