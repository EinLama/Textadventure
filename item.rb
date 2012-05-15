require_relative './entity'

class Item < Entity
  attr_accessor :name, :after_change
  attr_reader :actions
  
  def initialize(name)
    @name = name
    @actions = {
      :default => Proc.new { puts "You try to use #{name}: nothing happens." }
    }
  end
  
  def use(options={})
    if options.empty?
      action = @actions[:default]
    else
      action = @actions[options[:with].to_sym]
    end
    
    if action
      action.call(self) 
      make_from(@after_change)
    else
      puts "You can not use #{name} with #{options[:with]}."
    end
  end
  
  def on_use(options={}, &block)
    if options.empty?
      @actions[:default] = block
    else
      @actions[options[:with].to_sym] = block
    end
  end
  
  def changes_to(name, &block)
    item = Item.new(name)
    item.instance_eval(&block)
    @after_change = item
  end
  
  def to_s
    "<Item #{name}: \"#{description}\">"
  end
  
  private
  
  def make_from(other_item)
    # I want to say: self = @after_change, but this is prohibited.
    # Also, I can't go ahead and call #dup :/
    if other_item
      @name = other_item.name
      @description = other_item.description
      @actions = other_item.actions
      @after_change = other_item.after_change
    end
    
    self
  end
  
end
