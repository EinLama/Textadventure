class Entity
  attr_accessor :description
  
  def description(text=nil)
    @description = text unless text.nil?
    @description
  end
end
