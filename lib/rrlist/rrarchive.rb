require File.expand_path('../rrlist', __FILE__)

# Why do I need this class?
# What the purpose of this?
# Decorate RRList and add flush ?
# Is in it better to pass a DiskArray object to RRlist and call flush outisde RRList? <---
# Perhaps made RRArchive be a RRListComposite that olds many RRList and controls the LifeCycle of Flush, SerDi and before_add ?
class RRArchive

  DEFAULT_SERDI_STRATEGY = Marshal

  def self.load(filename,options={})
    strategy = options[:strategy] || DEFAULT_SERDI_STRATEGY

    data = strategy.load(File.open(filename,"r").read)

    RRArchive.new filename,
      :size => data[:size],
      :range => data[:range],
      :values => data[:values],
      :position => data[:position],
      :overal_position => data[:overal_position],
  end

  def initialize(filename, options)
    @rr_list = RRList.new options
    @filename = filename
    @strategy = options[:strategy] || DEFAULT_SERDI_STRATEGY
  end

  def add_at(index,value)
    @rr_list.add_at(index,value)
  end

  def add(value)
    @rr_list.add(value)
  end

  def rr_list
    @rr_list
  end

  def flush
    data = {
      size: rr_list.size,
      range: rr_list.range,
      values:rr_list.raw_values,
      position: rr_list.position,
      overal_position: rr_list.overal_position
    }

    File.open(@filename,"w")  do |f|
      f.write @strategy.dump(data)
    end
  end

end