require 'spec_helper'
require 'fileutils'

describe RRComposite do
  before :each do
    @location = File.expand_path('../../tmp/test/my_metrics', __FILE__)
    @file_out = File.join(@location,"rrcomposite.rra")
  end

  it "should add to multple " do
    rr_composite = RRComposite.new([{:size => 10 ,:range => 1},{:size => 10 ,:range => 5},{:size => 10 ,:range => 10}])
    0.upto 100 do |num|
      rr_composite.add_at(num,num)
    end

    rr_composite.add_at(149,149)

    rr_composite.values.should eq [[nil, nil, nil, nil, nil, nil, nil, nil, nil, 149], [100, nil, nil, nil, nil, nil, nil, nil, nil, 149], [59, 69, 79, 89, 99, 100, nil, nil, nil, 149]]
  end

  context "persist" do
    it "should create directory and dump rrlist contents in files and load back" do
      FileUtils.rm_rf(@location)
      FileUtils.mkdir_p(@location)
      rr_composite = RRComposite.new([{:size => 10 ,:range => 1},{:size => 10 ,:range => 5},{:size => 10 ,:range => 10}])
      0.upto 100 do |num|
        rr_composite.add_at(num,num)
      end

      rr_composite.values.should eq [[91, 92, 93, 94, 95, 96, 97, 98, 99, 100], [59, 64, 69, 74, 79, 84, 89, 94, 99, 100], [19, 29, 39, 49, 59, 69, 79, 89, 99, 100]]

      res = rr_composite.persist(@file_out)

      res.should be true

      File.exists?(@file_out).should be true
      File.open(@file_out,"r").read.should_not be_empty

      rr_composite_loaded = RRComposite.load(@file_out)

      rr_composite_loaded.values.should eq [[91, 92, 93, 94, 95, 96, 97, 98, 99, 100], [59, 64, 69, 74, 79, 84, 89, 94, 99, 100], [19, 29, 39, 49, 59, 69, 79, 89, 99, 100]]
    end


    it "should persist after_add function" do
      FileUtils.rm_rf(@location)
      FileUtils.mkdir_p(@location)
      rr_composite = RRComposite.new([{:size => 10 ,:range => 1},{:size => 10 ,:range => 5, :before_add => :average },{:size => 10 ,:range => 10, :before_add => :average}])
      0.upto 100 do |num|
        rr_composite.add_at(num,num)
      end

      rr_composite.values.should eq [[91, 92, 93, 94, 95, 96, 97, 98, 99, 100], [{:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>92.0, :size=>5}, {:value=>97.0, :size=>5}, {:value=>100, :size=>1}], [{:value=>14.5, :size=>10}, {:value=>24.5, :size=>10}, {:value=>34.5, :size=>10}, {:value=>44.5, :size=>10}, {:value=>54.5, :size=>10}, {:value=>64.5, :size=>10}, {:value=>74.5, :size=>10}, {:value=>84.5, :size=>10}, {:value=>94.5, :size=>10}, {:value=>100, :size=>1}]]

      res = rr_composite.persist(@file_out)

      res.should be true

      File.exists?(@file_out).should be true
      File.open(@file_out,"r").read.should_not be_empty

      rr_composite_loaded = RRComposite.load(@file_out)

      rr_composite_loaded.values.should eq [[91, 92, 93, 94, 95, 96, 97, 98, 99, 100], [{:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>92.0, :size=>5}, {:value=>97.0, :size=>5}, {:value=>100, :size=>1}], [{:value=>14.5, :size=>10}, {:value=>24.5, :size=>10}, {:value=>34.5, :size=>10}, {:value=>44.5, :size=>10}, {:value=>54.5, :size=>10}, {:value=>64.5, :size=>10}, {:value=>74.5, :size=>10}, {:value=>84.5, :size=>10}, {:value=>94.5, :size=>10}, {:value=>100, :size=>1}]]
      rr_composite_loaded.add_at(101,101)
      rr_composite_loaded.values.should eq [[92, 93, 94, 95, 96, 97, 98, 99, 100, 101], [{:value=>57.0, :size=>5}, {:value=>62.0, :size=>5}, {:value=>67.0, :size=>5}, {:value=>72.0, :size=>5}, {:value=>77.0, :size=>5}, {:value=>82.0, :size=>5}, {:value=>87.0, :size=>5}, {:value=>92.0, :size=>5}, {:value=>97.0, :size=>5}, {:value=>100.5, :size=>2}], [{:value=>14.5, :size=>10}, {:value=>24.5, :size=>10}, {:value=>34.5, :size=>10}, {:value=>44.5, :size=>10}, {:value=>54.5, :size=>10}, {:value=>64.5, :size=>10}, {:value=>74.5, :size=>10}, {:value=>84.5, :size=>10}, {:value=>94.5, :size=>10}, {:value=>100.5, :size=>2}]]
      200.upto 300 do |num|
        rr_composite_loaded.add_at(num,num)
      end
      rr_composite_loaded.values.should eq [[291, 292, 293, 294, 295, 296, 297, 298, 299, 300], [{:value=>257.0, :size=>5}, {:value=>262.0, :size=>5}, {:value=>267.0, :size=>5}, {:value=>272.0, :size=>5}, {:value=>277.0, :size=>5}, {:value=>282.0, :size=>5}, {:value=>287.0, :size=>5}, {:value=>292.0, :size=>5}, {:value=>297.0, :size=>5}, {:value=>300, :size=>1}], [{:value=>214.5, :size=>10}, {:value=>224.5, :size=>10}, {:value=>234.5, :size=>10}, {:value=>244.5, :size=>10}, {:value=>254.5, :size=>10}, {:value=>264.5, :size=>10}, {:value=>274.5, :size=>10}, {:value=>284.5, :size=>10}, {:value=>294.5, :size=>10}, {:value=>300, :size=>1}]]
    end
  end

end