require 'spec_helper'
require 'fileutils'

# I shuld be able to:
#   rrtime create file.rrt 10
#   rrtime update file.rrt now 1
#   rrtime update file.rrt now 2
#   rrtime update file.rrt now 3
#   rrtime update file.rrt display

describe "rrtime" do
  it "should create and update database" do
    @location = File.expand_path('../../tmp/test/my_metrics', __FILE__)
    @file_out = File.join(@location,"rrcomposite.rra")
    FileUtils.rm_rf(@location)
    FileUtils.mkdir_p(@location)

    cmd = File.expand_path('../../../bin/rrtime', __FILE__)

    run "#{cmd} create #{@file_out} 10"

    File.exists?(@file_out).should be true

    1.upto 11 do |n|
      run "#{cmd} update #{@file_out} now #{n}"
      sleep 1
    end

    rr_composite = RRComposite.load(@file_out)

    p rr_composite.values

    run "#{cmd} display #{@file_out} 0"
  end


  def run(cmd)
   st = Time.now
   out =  `#{cmd}`
   et = Time.now

   p ">" * 100
   puts out
   p  "#{et-st} " + ("<" * 100)
  end
end