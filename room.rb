require_relative './entity'
require_relative './item'

class Room < Entity
  attr_accessor :connected_rooms, :items
  attr_writer :spawn
  
  def initialize
    @spawn = false
    @items = []
    @connected_rooms = {}
  end
  
  def spawn?
    @spawn
  end
  
  def self.build(&block)
    room = Room.new
    block.arity < 1 ? room.instance_eval(&block) : block.call(room)
    room
  end
  
  # This needs some refactoring!
  # Also, I want to be able to freely specify the direction: up, down, around_the_corner, etc.
  # Need to find a method_missing-hook that is given a block instead of *args
  def west(&block)
    room_in_west = Room.new
    room_in_west.instance_eval(&block)
    @connected_rooms[:west] = room_in_west
    room_in_west[:east] ||= self
    room_in_west
  end
  
  def east(&block)
    room_in_east = Room.new
    room_in_east.instance_eval(&block)
    @connected_rooms[:east] = room_in_east
    room_in_east[:west] ||= self
    room_in_east
  end
  
  def north(&block)
    room_in_north = Room.new
    room_in_north.instance_eval(&block)
    @connected_rooms[:north] = room_in_north
    room_in_north[:south] ||= self
    room_in_north
  end
  
  def south(&block)
    room_in_south = Room.new
    room_in_south.instance_eval(&block)
    @connected_rooms[:south] = room_in_south
    room_in_south[:north] ||= self
    room_in_south
  end
  
  def [](name)
    @connected_rooms[name]
  end
  
  def []=(name, room)
    @connected_rooms[name] = room
  end
  
  def item(name, &block)
    item = Item.new(name)
    item.instance_eval(&block)
    @items << item
    item
  end
  
  # This does not work for method_missing(name, *args, &block)
  # def method_missing(name, *args)
  #   super unless name =~ /^go_(\w+)/
  #   puts "method missing with #{name}, #{args}"
  # end
  
  def to_s
    "<Room: \"#{description}\">"
  end
  
  # [:west, :north].each do |name|
  #   define_method(name) do
  #     room = Room.new
  #     room.instance_eval(&block)
  #     room
  #   end
  # end
  
end
