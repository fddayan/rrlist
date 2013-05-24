require File.expand_path('../rrlist', __FILE__)
require 'fileutils'

class RRComposite

  def initialize(options,values = nil)
    @options = options

    @rr_lists = []
    for o in options
      @rr_lists << case o
                      when Hash
                        RRList.new(o)
                      when RRList
                        o
                    end
    end
  end

  def rr_lists
    @rr_lists
  end

  def add_at(index,value)
    @rr_lists.each do |rr_list|
      rr_list.add_at(index,value)
    end
  end

  def add(value)
    @rr_lists.each do |rr_list|
      rr_list.add(index,value)
    end
  end

  def values
    @rr_lists.collect {|rr| rr.values}
  end

  def values_for(rr_list_index)
    @rr_lists[index]
  end

  def persist(location)
    to_dump = {
      rrlists: @rr_lists.collect { |rrl| rrl.dump }
    }

    File.open(location,"w") do |f|
      f.write Marshal.dump(to_dump)
    end

    true
  end

  def self.load(location)
    loaded = Marshal.load(File.open(location,"r").read)
    rr_lists = loaded[:rrlists].collect { |l| RRList.new(l) }

    return RRComposite.new(rr_lists)
  end

end