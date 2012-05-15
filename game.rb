
class Game
  attr_accessor :current_room
  attr_reader :commands
  attr_writer :running
  
  def initialize(spawn_room)
    @current_room = spawn_room
    @commands = { 
      "help" => :help,
      "go" => :go,
      "look" => :look,
      "use" => :use_item,
      "exit" => :exit,
      "quit" => :exit # There should be a more elegant way to enable an alias for a command
    }
  end
  
  def running?
    @running
  end
  
  def run
    @running = true
    while running?
      prompt
      process_input
    end
  end
  
  def self.run(spawn_room)
    game = Game.new(spawn_room)
    game.run
  end
  
  def prompt
    print "> "
  end
  
  def use_item(*args)
    phrase = args.join(" ")
    
    # <item name> with <something>
    if phrase =~ /^(.+)\swith\s(.+)$/
      item = $1
      use_with = $2
    else
      item = phrase
    end
    
    item = @current_room.items.find { |i| i.name == item }
    
    if item
            
      if use_with
        item.use :with => use_with
      else
        item.use
      end
      
    else
      puts "There is no such item: #{item}"
    end
      
  end
  
  def help(*args)
    
    unless args.empty?
      case args.first
      when "go"
        puts "help for the go-command: lorem ipsum..."
      else
        puts "i have no idea what you mean :D"
      end
    else
      output = "List of all commands:\n"
      output << @commands.keys.join("\n")
      puts "#{output}\n\n"
    end
  end
  
  def exit(*args)
    puts "Goodbye!"
    @running = false
  end
  
  def go(*where)
    if where.empty?
      puts "You must specify a place to go."
      return
    end
    
    where = where.first.downcase
    
    if @current_room.connected_rooms.key? where.to_sym
      @current_room = @current_room.connected_rooms[where.to_sym]
      puts "You went to #{where}."
      look
    else
      puts "There is no such place: #{where}."
    end
    
  end
  
  def look(*at)
    if at.empty?
      puts "You look around:\n\t#{@current_room.description}\n\n"
      
      items = @current_room.items.map { |i| "\t" << i.name }.join("\n")
      
      puts "Items:\n#{items}" unless items.empty?
      puts "Exits:\n#{@current_room.connected_rooms.keys.join("\n")}"
    else
      at = at.flatten.join(" ")
      item = @current_room.items.find { |i| i.name.downcase == at.downcase }
      
      if item
        puts "You look at #{item.name}:\n\t#{item.description}"
      else
        puts "There is no such thing to look at: #{at}"
      end
    end
  end
  
  def process_input
    input = gets.chomp.split(/\s/)
    command = input.first
    args = input[1..input.size]
    
    if @commands.key? command
      send(@commands[command], *args)
    else
      puts "Unknown command: #{command}. Type \"help\" to get a list with available commands."
    end
    
    input
  end
  
end
