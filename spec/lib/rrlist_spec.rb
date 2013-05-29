require 'spec_helper'

describe RRList::List do

  subject do
    RRList::List.new(:size => 10 ,:range => 1).tap  do |rr_list|
      0.upto(30) { |v| rr_list.add(v) }
    end
  end

  it { subject.get(22).should be 22 }

  it { subject.min_index.should be 21 }
  it { subject.max_index.should be 30 }

  it { subject.index_size.should be 10 }

  it { subject.in_limits?(20).should be false }
  it { subject.in_limits?(21).should be true }
  it { subject.in_limits?(30).should be true }
  it { subject.in_limits?(31).should be false }

  it { subject.out_of_range?(1).should be true }
  it { subject.out_of_range?(15).should be false }
  it { subject.out_of_range?(20).should be false }
  it { subject.out_of_range?(100).should be true }

  it { subject.lower?(20).should be true }
  it { subject.lower?(21).should be false }

  it { subject.higher?(30).should be false }
  it { subject.higher?(31).should be true }

  it { subject.values.should eq [21,22,23,24,25,26,27,28,29,30] }

  it "each should iterate over the list" do
    subject.each { |v| v.should_not be_nil }
  end

  context ".each_with_index" do

    it "should iterate over passing the rigth index" do
      rr_list = RRList::List.new :size => 10 ,:range => 5
      0.upto(100) { |v| rr_list.add_at(v,v) }

      res = {}
      rr_list.each_with_index do |value, index|
        res[index.to_s] = value
      end

      res.should eq "55"=>59, "60"=>64, "65"=>69, "70"=>74, "75"=>79, "80"=>84, "85"=>89, "90"=>94, "95"=>99, "100"=>100
    end
  end

  context "add_at" do

    it "should move to the right if added a higher index" do
      subject.add_at(31,31)

      subject.min_index.should be 22
      subject.max_index.should be 31
      subject.values.should eq [22,23,24,25,26,27,28,29,30,31]
    end

    it "should fail if index value is lower than index" do
      lambda { subject.add_at(29,29) }.should raise_exception
    end

    it "out of range shoudld lose all values" do
      subject.add_at(200,200)

      subject.min_index.should be 191
      subject.max_index.should be 200
      subject.values.should eq [nil,nil,nil,nil,nil,nil,nil,nil,nil,200]
    end

    it "should add zero" do
      rr_list = RRList::List.new :size => 10

      0.upto(5) { |v| rr_list.add_at(v,v) }

      rr_list.values.should eq [0,1,2,3,4,5,nil,nil,nil,nil]
    end

    it "without never calling .add should work anyway" do
      rr_list = RRList::List.new :size => 10

      0.upto(50) { |v| rr_list.add_at(v,v) }

      rr_list.values.should eq [41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
    end
  end

  context "before_add" do

    it "should load proc from symbols" do
      rr_list = RRList::List.new :size => 10 ,:range => 5, &RRMath.get_function_prod(:avg)

      0.upto(40) do |v|
        rr_list.add_at(v,v)
      end

      rr_list.values.size.should be 10
      rr_list.values.should eq [{:value=>2.0, :size=>5}, {:value=>7.0, :size=>5}, {:value=>12.0, :size=>5}, {:value=>17.0, :size=>5}, {:value=>22.0, :size=>5}, {:value=>27.0, :size=>5}, {:value=>32.0, :size=>5}, {:value=>37.0, :size=>5}, {:value=>40, :size=>1}, nil]
    end

    it "when rotating the list old values get used by before_add because do not get removed." do
      rr_list = RRList::List.new :size => 10 ,:range => 5 do |index,old_value,new_value|
        if old_value
          {
            value: RRMath.average(old_value[:size],old_value[:value],new_value),
            size: old_value[:size] + 1
          }
        else
          {
            value: new_value,
            size: 1,
          }
        end
      end

      0.upto(200) do |v|
        rr_list.add_at(v,v)
      end

      rr_list.values.size.should be 10
      rr_list.values.should eq [{:value=>157.0, :size=>5}, {:value=>162.0, :size=>5}, {:value=>167.0, :size=>5}, {:value=>172.0, :size=>5}, {:value=>177.0, :size=>5}, {:value=>182.0, :size=>5}, {:value=>187.0, :size=>5}, {:value=>192.0, :size=>5}, {:value=>197.0, :size=>5}, {:value=>200, :size=>1}]
    end

    it "should apply agregate function before replacing position on range" do
      rr_list = RRList::List.new :size => 10 ,:range => 5 do |index,old_value,new_value|
        if old_value
          {
            value: RRMath.average(old_value[:size],old_value[:value],new_value),
            size: old_value[:size] + 1
          }
        else
          {
            value: new_value,
            size: 1,
          }
        end
      end

      0.upto(40) do |v|
        rr_list.add_at(v,v)
      end

      rr_list.values.size.should be 10
      rr_list.values.should eq [{:value=>2.0, :size=>5}, {:value=>7.0, :size=>5}, {:value=>12.0, :size=>5}, {:value=>17.0, :size=>5}, {:value=>22.0, :size=>5}, {:value=>27.0, :size=>5}, {:value=>32.0, :size=>5}, {:value=>37.0, :size=>5}, {:value=>40, :size=>1}, nil]
    end

     it "should apply agregate function before replacing position" do
      rr_list = RRList::List.new :size => 10 ,:range => 1 do |index,old_value,new_value|
        if old_value
          {
            value: RRMath.average(old_value[:size],old_value[:value],new_value),
            size: old_value[:size] + 1
          }
        else
          {
            value: new_value,
            size: 1,
          }
        end
      end

      rr_list.add_at(1,2)
      rr_list.add_at(1,3)
      rr_list.add_at(1,4)
      rr_list.add_at(1,7)

      rr_list.values.should eq [nil, {:value=>4.0, :size=>4}, nil, nil, nil, nil, nil, nil, nil, nil]
    end
  end

  it "should save times" do
    start_time = Time.utc(2000,"jan",1,20,15,1)
    end_time = start_time + (3600*24)
    rr_list = RRList::List.new :size => 24 ,:range => 3600  # 24 hours, 1 hours

    seconds = start_time
    while seconds < end_time
      rr_list.add_at(seconds.to_i,seconds.to_s)

      seconds += 1
    end

    rr_list.values.size.should be 24
  end

  it "add_at should set cursor at the end" do
    rr_list = RRList::List.new :size => 10

    rr_list.add_at(15,15)

    rr_list.add("a")
    rr_list.add("b")

    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, 15, "a", "b"]
  end

  it "should initialize array of size" do
    rr_list = RRList::List.new :size => 10

    rr_list.values.size.should be 10
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

    rr_list.add(1)

    rr_list.values.should eq [1, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  it "should add with range of 5 correctly" do
    rr_list = RRList::List.new :size => 10, :range => 5

    0.upto(100) do |v|
        rr_list.add_at(v,v)
    end

    rr_list.index_size.should eq 50
    rr_list.max_index.should eq 100
    rr_list.min_index.should eq 55

    55.upto(104) do |v|
      rr_list.in_limits?(v).should be true
    end

    rr_list.in_limits?(52).should be false
    rr_list.in_limits?(105).should be false

    rr_list.higher?(103).should be false
    rr_list.higher?(104).should be false
    rr_list.higher?(105).should be true

    rr_list.lower?(52).should be true
    rr_list.lower?(53).should be true
    rr_list.lower?(54).should be true
    rr_list.lower?(55).should be false

    (55-50+1).upto((104+50-5)) do |v|
      rr_list.out_of_range?(v).should be false
    end
    rr_list.out_of_range?(1).should be true
    rr_list.out_of_range?(104+50-4).should be true

    rr_list.values.should eq [59, 64, 69, 74, 79, 84, 89, 94, 99, 100]
    rr_list.add_at(105,105)
    rr_list.values.should eq [64, 69, 74, 79, 84, 89, 94, 99, 100, 105]
    rr_list.add_at(1005,1005)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, 1005]
  end

  it "test_add_with_range_of_2" do
    rr_list = RRList::List.new :size => 10, :range => 2

    0.upto(100) do |v|
        rr_list.add_at(v,v)
    end

    rr_list.values.should eq [83, 85, 87, 89, 91, 93, 95, 97, 99, 100]
  end

  it "question should return valid" do
    rr_list = RRList::List.new :size => 10

    pop(rr_list)

    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.min_index.should eq 11
    rr_list.max_index.should eq 20

    11.upto(20) do |v|
      rr_list.in_limits?(v).should be true
    end

    rr_list.in_limits?(10).should be false
    rr_list.in_limits?(22).should be false

    rr_list.higher?(10).should be false
    rr_list.higher?(20).should be false
    rr_list.higher?(21).should be true
    rr_list.higher?(22).should be true

    rr_list.lower?(10).should be true
    rr_list.lower?(11).should be false
    rr_list.lower?(21).should be false

    2.upto(29) do |v|
      rr_list.out_of_range?(v).should be false
    end
    rr_list.out_of_range?(1).should be true
    rr_list.out_of_range?(31).should be true
  end

  it "test_sequences" do
    rr_list = RRList::List.new :size => 10

    pop(rr_list)

    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at(87,87)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, 87]
    rr_list.add(88)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, 87, 88]
    rr_list.add_at(90,90)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, 87, 88, nil, 90]
    rr_list.add_at(100,100)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil,nil, 100]
    rr_list.add_at(101,101)
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil,nil, nil,100, 101]
  end

  it "should insert correctly with a much greater number" do
    rr_list = RRList::List.new :size => 10

    pop(rr_list)

    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 122,122

    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, 122]
  end


  it "add higher number should rotate to left and add nill" do
    rr_list = RRList::List.new :size => 10

    pop(rr_list)

    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 22,22

    rr_list.values.should eq [13, 14, 15, 16, 17, 18, 19, 20, nil, 22]
  end

  it "should set right size and value in position" do
    rr_list = RRList::List.new :size => 10

    0.upto(25) do |v|
      rr_list.add(v)
    end

    vals = rr_list.values

    vals.size.should eq 10
    vals[0].should eq 16
    vals[vals.size-1].should eq 25
    rr_list.max_index.should eq 25
  end

  context "Array API" do

    it "should set with [index]=value" do
      subject[35] = 35

      subject.min_index.should be 26
      subject.max_index.should be 35
      subject.values.should eq [26, 27, 28, 29, 30, nil, nil, nil, nil, 35]
    end

    it "should get value with [index]" do
      subject[22].should be 22
      subject[23].should be 23
      subject[24].should be 24
    end
  end

  def pop(rr_list)
     0.upto(20) do |v|
      rr_list.add(v)
    end
  end

  def dg(rr_list)
    p "=" * 100
    p "#{rr_list.min_index},#{rr_list.max_index}"
    p rr_list.values
  end

  def days(days)
    60*60*24*days
  end
end