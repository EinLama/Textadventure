#require 'yaml'

require_relative './game'
require_relative './room'

first_room = Room.build do
  description "You are in a small, shady room. It's quite cold in here. There is an old table in the middle of the room."
  
  item "table" do
    description "The table is made of wood and seems to be very old, due to usetrails and dust on the surface. You can't find anything interesting here."
  end
  
  west do
    description "this is another great room in the west!"
  end
  
  east do
    description "this is the room in the east"

    north do
      description "Another room, now to the north."
    end

    item "red key" do 
      description "simply put, you can open a door with it."
      
      on_use(:with => :red_door) do
        puts "You can now open the door!"
      end
    end
    
    item "ragged cloth" do
      description "Just some old, raggy cloth. It's moist and smells."
      
      on_use(:with => :lars) do
        puts "used #{name} with lars: 'Something happens!'"
      end
      
      on_use(:with => :water) do
        puts "you have washed #{name} with water."
        
        changes_to "clean cloth" do
          description "Clean cloth. You could wear it."
        end
      end
      
      on_use do
        puts "used #{name} with nothing: 'it smells...'"
      end
    end
  end
  
end



# puts first_room[:east]
# puts first_room[:east].items
# puts first_room
# puts first_room.connected_rooms[:east][:north]
# 
# first_room[:east].items[1].use :with => :lars
# first_room[:east].items[1].use
# 
# y first_room
# 
# clean_cloth = first_room[:east].items[1].use :with => :water
# y clean_cloth

Game.run(first_room)
