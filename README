= WORK IN PROGRESS

Inspired by `RRDTool`
Basically, you can add elements to a list, but the sizes remains constant over time.
If you add an element to to the list that is out of the range, moves the cursor forward and items at the lower indexes are lost. For example:

[1,2,3,4,5]
add 6
[2,3,4,5,6]
add 7
[3,4,5,6,7]

=== Install

    gem install rrlist

    gem 'rrlist'

== Usage

*Basic*

    require 'rrlist'

    rrlist = RRList::List.new :size => 10

    rrlist.values #=> [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

    1.upto(100) { |n| rrlist.add(n) }

    rrlist.values     #=> [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
    rrlist.min_index  #=> 91
    rrlist.min_index  #=> 100
    rrlist.get(93)    #=> 93

    rrlist.each {  |value| ... }
    rrlist.each_with_index {  |value,index| puts "#{value} #{index}" }
    # => 91 91
    # => 92 92
    ....

    rrlist.add(101)

    rrlist.values     #=> [92, 93, 94, 95, 96, 97, 98, 99, 100, 101]
    rrlist.min_index  #=> 92
    rrlist.min_index  #=> 101

    rrlist.add("any object")

    rrlist.values     #=> [93, 94, 95, 96, 97, 98, 99, 100, 101, "any object"]
    rrlist.min_index  #=> 93
    rrlist.min_index  #=> 102

    rrlist.add_at 105, "A"
    rrlist.values     #=> [96, 97, 98, 99, 100, 101, "any object", nil, nil, "A"]
    rrlist.min_index  #=> 96
    rrlist.max_index  #=> 105

    rrlist.add_at 2000,"B"
    rrlist.add_at 105, "A"
    rrlist.values         #=> [nil, nil, nil, nil, nil, nil, nil, nil, nil, "B"]
    rrlist.min_index      #=> 1991
    rrlist.max_index      #=> 2000

*Ranges*
    rrlist = RRList::List.new :size => 10, :range => 5

    0.upto(100) { |n| rrlist.add(n) }

    rrlist.values     #=> [59, 64, 69, 74, 79, 84, 89, 94, 99, 100]
    rrlist.min_index  #=> 55
    rrlist.max_index  #=> 100


*Functions*
To sum all the values added to a range

    rrlist = RRList::List.new :size => 10, :range => 5 do |index, old_value, new_value|
      (old_value||0) + new_value
    end

    0.upto(100) { |n| rrlist.add(n) }

    rrlist.values     #=> [285, 310, 335, 360, 385, 410, 435, 460, 485, 100]
    rrlist.min_index  #=> 55
    rrlist.max_index  #=> 100






