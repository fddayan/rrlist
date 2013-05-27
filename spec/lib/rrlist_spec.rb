require 'spec_helper'

describe RRList do

  context ".each_with_index" do

    it "should iterate over passing the rigth index" do
      rr_list = RRList.new :size => 10 ,:range => 5
      0.upto(100) { |v| rr_list.add_at(v,v) }

      res = {}
      rr_list.each_with_index do |value, index|
        res[index.to_s] = value
      end
      
      res.should eq "55"=>59, "60"=>64, "65"=>69, "70"=>74, "75"=>79, "80"=>84, "85"=>89, "90"=>94, "95"=>99, "100"=>100
    end
  end

  # context "rotate" do
  #     before :each do
  #       @rr_list1 = RRList.new :size => 10 ,:range => 1
  #       @rr_list2 = RRList.new :size => 10 ,:range => 5
  #       @rr_list3 = RRList.new :size => 10 ,:range => 10
  # 
  #       @rr_list1.after_rotate do |index, value|
  #         @rr_list2.add_at(index,value)
  #       end
  # 
  #       @rr_list2.after_rotate do |index, value|
  #         @rr_list3.add_at(index,value)
  #       end
  # 
  #       @rr_list2.before_add do |index, old_value, new_value|
  #         if old_value
  #           {
  #             value: RRMath.average(old_value[:size],old_value[:value],new_value),
  #             size: old_value[:size] + 1
  #           }
  #         else
  #           {
  #             value: new_value,
  #             size: 1,
  #           }
  #         end
  #       end
  # 
  #       @rr_list3.before_add do |index, old_value, new_value|
  #         if old_value
  #           {
  #             value: RRMath.average(old_value[:size],old_value[:value],new_value[:value],new_value[:size]),
  #             size: old_value[:size] + new_value[:size]
  #           }
  #         else
  #           {
  #             value: new_value[:value],
  #             size: new_value[:size],
  #           }
  #         end
  #       end
  # 
  #     end
  # 
  # 
  #     it "when values is lower" do
  #       0.upto(9) do |v|
  #         @rr_list1.add_at(v+100,v+100)
  #       end
  # 
  #       @rr_list1.values.should eq [100, 101, 102, 103, 104, 105, 106, 107, 108, 109]
  #       @rr_list2.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  # 
  #       @rr_list1.add_at(99,99)
  #       @rr_list1.add_at(98,98)
  # 
  #       @rr_list1.values.should eq [98, 99, 100, 101, 102, 103, 104, 105, 106, 107]
  #       @rr_list2.values.should eq [nil, nil, nil, nil, nil, nil, nil, {:value=>108.5, :size=>2}, nil, nil]
  #     end
  # 
  #     it "should do something with all the values removed when value is lower out of range" do
  #       0.upto(9) do |v|
  #         @rr_list1.add_at(v+100,v+100)
  #       end
  # 
  #       @rr_list1.values.should eq [100, 101, 102, 103, 104, 105, 106, 107, 108, 109]
  #       @rr_list2.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  # 
  #       @rr_list1.overal_position.should be 110
  #       @rr_list2.overal_position.should be 0
  # 
  #       @rr_list1.add_at(10,10)
  # 
  #       # @rr_list1.values.should eq [10, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  #       @rr_list2.values.should eq [{:value=>102.0, :size=>5}, {:value=>107.0, :size=>5}, nil, nil, nil, nil, nil, nil, nil, nil]
  #       @rr_list1.overal_position.should be 20
  #       @rr_list2.overal_position.should be 110
  #     end
  # 
  #     it "should do something with all the values removed when value is higher out of range" do
  #       0.upto(9) do |v|
  #         @rr_list1.add_at(v,v)
  #       end
  # 
  #       @rr_list1.values.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  #       @rr_list2.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  # 
  #       @rr_list1.add_at(200,200)
  # 
  #       @rr_list1.values.should eq [200, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  #       @rr_list2.values.should eq [{:value=>2.0, :size=>5}, {:value=>7.0, :size=>5}, nil, nil, nil, nil, nil, nil, nil, nil]
  #       @rr_list1.overal_position.should be 210 # because it's at the end of the list index + (@size-pos)
  #       @rr_list2.overal_position.should be 9
  #     end
  # 
  #     it "when value is higher it should do soemthing with the replaced value before losing it" do
  #       0.upto(100) do |v|
  #         @rr_list1.add_at(v,v)
  #       end
  # 
  #       @rr_list1.values.should eq [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
  #       @rr_list2.values.should eq [{:value=>47.0, :size=>5}, {:value=>52.0, :size=>5}, {:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>90, :size=>1}]
  #       @rr_list3.values.should eq [{:value=>4.5, :size=>10}, {:value=>14.5, :size=>10}, {:value=>24.5, :size=>10}, {:value=>34.5, :size=>10}, {:value=>42.0, :size=>5}, nil, nil, nil, nil, nil]
  #     end
  #   end


  it '.add_at should add zero' do
    rr_list = RRList.new :size => 10

    0.upto(5) do |v|
      rr_list.add_at(v,v)
    end

    rr_list.values.should eq [0,1,2,3,4,5,nil,nil,nil,nil]
  end

  it "add_at without never calling .add should work anyway" do
    rr_list = RRList.new :size => 10

    0.upto(50) do |v|
      rr_list.add_at(v,v)
    end

    rr_list.values.should eq [41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
  end

  context ".before_add" do

    it "should load proc from symbols" do
      rr_list = RRList.new :size => 10 ,:range => 5, :before_add => :avg

      0.upto(40) do |v|
        rr_list.add_at(v,v)
      end

      rr_list.values.size.should be 10
      rr_list.values.should eq [{:value=>2.0, :size=>5}, {:value=>7.0, :size=>5}, {:value=>12.0, :size=>5}, {:value=>17.0, :size=>5}, {:value=>22.0, :size=>5}, {:value=>27.0, :size=>5}, {:value=>32.0, :size=>5}, {:value=>37.0, :size=>5}, {:value=>40, :size=>1}, nil]
    end

    it "bug found: when rotating the list old values get used by before_add because do not get removed." do
      rr_list = RRList.new :size => 10 ,:range => 5

      rr_list.before_add do |index,old_value,new_value|
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
      rr_list = RRList.new :size => 10 ,:range => 5

      rr_list.before_add do |index,old_value,new_value|
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
      rr_list = RRList.new :size => 10 ,:range => 1

      rr_list.before_add do |index,old_value,new_value|
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
    rr_list = RRList.new :size => 24 ,:range => 3600  # 24 hours, 1 hours

    seconds = start_time
    while seconds < end_time
      rr_list.add_at(seconds.to_i,seconds.to_s)

      seconds += 1
    end

    rr_list.values.size.should be 24
    # p rr_list.values
  end

  it "update_at should update index without moving cursos" do
    rr_list = RRList.new :size => 10

    rr_list.add_at(15,15)
    rr_list.add("a")
    rr_list.update_at(13,13)
    rr_list.add("b")
    # rr_list.values.should eq [nil, 13, nil, 15, nil, nil, nil, nil, "a", "b"]
    rr_list.values.should eq [nil, nil, nil, 13, "b", 15, "a", nil, nil, nil]
  end

  it ".move_ should move curso to position, but keep overal position of list" do
    pending "@position is not the same as the begining of the list, we should add a @cursor_positon"

    rr_list = RRList.new :size => 10

    rr_list.add_at(15,15)

    rr_list.move_first
    rr_list.add(12)
    rr_list.add(13)
  end

  it ".move_cursor_to should move cursos to position to add" do
    pending "@position is not the same as the begining of the list, we should add a @cursor_positon"
    rr_list = RRList.new :size => 10

    rr_list.add_at(15,15)
    rr_list.move_cursor_to(16)
    rr_list.add(16)

    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, 15, 16]

    rr_list.add(17)

    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, 15, 16, 17]

    rr_list.move_cursor_to(12)
    rr_list.add(12)

    # rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, 15, 16, 17]
  end

  it "add_at should set cursor at the end" do
    rr_list = RRList.new :size => 10

    rr_list.add_at(15,15)
    rr_list.add("a")
    rr_list.add("b")

    rr_list.values.should eq [nil, nil, nil, nil, nil, 15, "a", "b", nil, nil]
  end


  it "should initialize array of size" do
    rr_list = RRList.new :size => 10

    rr_list.values.size.should be 10
    rr_list.values.should eq [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

    rr_list.add(1)

    rr_list.values.should eq [1, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  it "test_add_with_range_of_5" do
    rr_list = RRList.new :size => 10, :range => 5

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
    rr_list.values.should eq [nil, 1005, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(2,2)
    rr_list.values.should eq [2, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(10,10)
    rr_list.values.should eq [2, nil, 10, nil, nil, nil, nil, nil, nil, nil]
  end

  it "test_add_with_range_of_2" do
    rr_list = RRList.new :size => 10, :range => 2

    0.upto(100) do |v|
        rr_list.add_at(v,v)
    end

    rr_list.values.should eq [83, 85, 87, 89, 91, 93, 95, 97, 99, 100]
  end

  it "question should return valid" do
    rr_list = RRList.new :size => 10

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
    rr_list = RRList.new :size => 10 , :verbose => false

    pop(rr_list)

    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at(15,15)
    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    rr_list.add_at(100,100)
    rr_list.values.should eq [100, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(101,101)
    rr_list.values.should eq [100, 101, nil, nil, nil, nil, nil, nil, nil,nil]
    rr_list.add_at(1,1)
    rr_list.values.should eq [nil,1, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(2,2)
    rr_list.values.should eq [nil,1, 2, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(90,90)
    rr_list.values.should eq [90, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(90,90)
    rr_list.values.should eq [90, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.add_at(87,87)
    rr_list.values.should eq [87, nil, nil, 90, nil, nil, nil, nil, nil, nil]
    rr_list.add(88)
    rr_list.values.should eq [87, 88, nil, 90, nil, nil, nil, nil, nil, nil]
  end

  it "test_add_at_with_much_greater_number" do
    rr_list = RRList.new :size => 10

    pop(rr_list)

    rr_list.raw_values.should eq [20,11, 12, 13, 14, 15, 16, 17, 18, 19]
    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 122,122

    rr_list.raw_values.should eq [nil,nil, 122, nil, nil, nil, nil, nil, nil, nil]
    rr_list.values.should eq [nil, nil, 122, nil, nil, nil, nil, nil, nil, nil]
  end

  it "test_add_at_with_much_lower_number" do
    rr_list = RRList.new :size => 10

    pop(rr_list)

    rr_list.raw_values.should eq [20,11, 12, 13, 14, 15, 16, 17, 18, 19]
    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 22,22
    rr_list.add_at 1,1

    rr_list.raw_values.should eq [nil,1, nil, nil, nil, nil, nil, nil, nil, nil]
    rr_list.values.should eq [nil,1, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  it "add higher number should rotate to left and add nill" do
    rr_list = RRList.new :size => 10

    pop(rr_list)

    rr_list.raw_values.should eq [20,11, 12, 13, 14, 15, 16, 17, 18, 19]
    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 22,22

    # rr_list.raw_values.should eq [20, nil, 22, 13, 14, 15, 16, 17, 18, 19]
    rr_list.values.should eq [13, 14, 15, 16, 17, 18, 19, 20, nil, 22]
  end

  it "should add at with lowernumber" do
    rr_list = RRList.new :size => 10

    pop(rr_list)

    rr_list.raw_values.should eq [20,11, 12, 13, 14, 15, 16, 17, 18, 19]
    rr_list.values.should eq [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    rr_list.add_at 8,8

    # rr_list.values.should eq [8, nil, nil, 11, 12, 13, 14, 15, 16, 17]
    rr_list.raw_values.should eq [nil,11, 12, 13, 14, 15, 16, 17, 8, nil]
  end

  it "should set right size and value in position" do
    rr_list = RRList.new :size => 10

    0.upto(25) do |v|
      rr_list.add(v)
    end

    vals = rr_list.values

    vals.size.should eq 10
    vals[0].should eq 16
    vals[vals.size-1].should eq 25
    rr_list.overal_position.should eq 25
  end


  def pop(rr_list)
     0.upto(20) do |v|
      rr_list.add(v)
    end
  end

  def dg(rr_list)
    p "=" * 100
    p "#{rr_list.min_index},#{rr_list.max_index}"
    p rr_list.raw_values
    p rr_list.values
  end

  def days(days)
    60*60*24*days
  end
end