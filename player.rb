class Player
  GRAVITY = 0.8
  attr_reader :x, :y, :previous_x, :previous_y
  
  def initialize(x, y, level)
    @x = x
    @y = y
    @level = level
    
    @velocity_x = 5
    
    @velocity_y = 0
    
    @image = Gosu::Image.new 'images/player.png'
  end
  
  def width
    @image.width
  end
  
  def height
    @image.height
  end
  
  def pass_portal(entrance)
    exit = @level.blocks.find { |block| block != entrance and block.portal_active? }
    return false unless exit
    
    if exit.active_side == :top
      @x = exit.x
      @y = exit.y - height
      
      @velocity_y = -@velocity_y
    elsif exit.active_side == :bottom
      @x = exit.x
      @y = exit.y + exit.height
    elsif exit.active_side == :left
      @x = exit.x - width
      @y = exit.y
    elsif exit.active_side == :right
      @x = exit.x + exit.width
      @y = exit.y
    end
  end
  
  def update
    @previous_x, @previous_y = @x, @y
    
    @x += @velocity_x if Gosu::button_down?(Gosu::KbD)
    @x -= @velocity_x if Gosu::button_down?(Gosu::KbA)
    
    @level.blocks.each do |block|
      collision_side = block.collides? self
      next unless collision_side
      
      if block.active_side == collision_side
        return if pass_portal(block)
      end
      
      if @x < block.x     # from left
        @x = block.x - width
      else                # from right
        @x = block.x + block.width
      end
    end
    
    @x = [0, @x, @level.width - width].sort[1]
    
    
    
    @velocity_y += GRAVITY
    
    @velocity_y = [-40, @velocity_y, 40].sort[1]
    
    @y += @velocity_y
    
    @level.blocks.each do |block|
      collision_side = block.collides? self
      next unless collision_side
      
      if block.active_side == collision_side
        return if pass_portal(block)
      end
      
      if @y < block.y     # from top
        @y = block.y - height
        
        @velocity_y = Gosu::button_down?(Gosu::KbSpace) ? -14 : 0 
      else                # from bottom
        @y = block.y + block.height
        
        @velocity_y = 0
      end
    end
    
    @y = [0, @y, @level.height - height].sort[1]
  end
  
  def draw
    @image.draw @x, @y, 100
  end
end