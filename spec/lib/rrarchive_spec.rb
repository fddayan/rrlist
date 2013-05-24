require 'spec_helper'

describe RRArchive do

  context "persist" do
    before :each do
      @tmp_dir = File.expand_path('../../tmp/test', __FILE__)
      @rr_file = File.join(@tmp_dir,"file.rra")
      File.delete(@rr_file) if File.exists?(@rr_file)
    end

    it "should work with agregations too" do
      rr_archive = RRArchive.new @rr_file,:size => 10,:range => 5

      rr_archive.rr_list.before_add &RRMath.agregate_proc

      0.upto 100 do |num|
        rr_archive.add_at(num,num)
      end

      # Make sure rrlist is valid
      rrlist_should_match(rr_archive.rr_list,10,5,1,100,[{:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>92.0, :size=>5}, {:value=>97.0, :size=>5}, {:value=>100, :size=>1}])

      rr_archive.flush

      rr_archive2 = RRArchive.load @rr_file

      # Make sure loaded rrlist is the same
      rrlist_should_match(rr_archive2.rr_list,10,5,1,100,[{:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>92.0, :size=>5}, {:value=>97.0, :size=>5}, {:value=>100, :size=>1}])

      rr_archive2.rr_list.before_add &RRMath.agregate_proc
      100.upto 200 do |num|
        rr_archive2.add_at(num,num)
      end

      # Make sure agregation function still works
      rrlist_should_match(rr_archive2.rr_list,10,5,1,200,[{:value=>157.0, :size=>5}, {:value=>162.0, :size=>5}, {:value=>167.0, :size=>5}, {:value=>172.0, :size=>5}, {:value=>177.0, :size=>5}, {:value=>182.0, :size=>5}, {:value=>187.0, :size=>5}, {:value=>192.0, :size=>5}, {:value=>197.0, :size=>5}, {:value=>200, :size=>1}])
    end

    it "should persist on disk and load back " do
      rr_archive = RRArchive.new @rr_file,:size => 10,:range => 5,:strategy => Marshal

      0.upto 100 do |num|
        rr_archive.add_at(num,num)
      end

      File.exists?(@rr_file).should be false

      rr_archive.flush

      rrlist_should_match(rr_archive.rr_list,10,5,1,100,[59, 64, 69, 74, 79, 84, 89, 94, 99, 100])

      File.exists?(@rr_file).should be true

      rr_archive2 = RRArchive.load @rr_file,:strategy => Marshal

      rrlist_should_match(rr_archive2.rr_list,10,5,1,100,[59, 64, 69, 74, 79, 84, 89, 94, 99, 100])

      100.upto 200 do |num|
        rr_archive2.add_at(num,num)
      end

      rrlist_should_match(rr_archive2.rr_list,10,5,1,200,[159, 164, 169, 174, 179, 184, 189, 194, 199, 200])

      0.upto 100 do |num|
        rr_archive2.add(num)
      end

      rrlist_should_match(rr_archive2.rr_list,10,5,2,705,[91, 92, 93, 94, 95, 96, 97, 98, 99, 100])
    end
  end
end