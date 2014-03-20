class Block
  attr_reader :x, :y, :portal_color, :active_side
  
  def initialize(x, y)
    @x = x
    @y = y
    @image = Gosu::Image.new 'images/block.png'
  end
  
  def width
    @image.width
  end
  
  def height
    @image.height
  end
  
  def draw
    @image.draw(@x, @y, 10)
    
    # this is gonna suck
    color = @portal_color == :blue ? Gosu::Color::CYAN : Gosu::Color::RED
    thickness = 10
    if @active_side == :top
      Gosu::draw_quad x, y, color,
                      x + width, y, color,
                      x, y + thickness, color,
                      x + width, y + thickness, color, 11
    elsif @active_side == :bottom
      Gosu::draw_quad x, y + height - thickness, color,
                      x + width, y + height - thickness, color,
                      x, y + height, color,
                      x + width, y + height, color, 11
    elsif @active_side == :left
      Gosu::draw_quad x, y, color,
                      x + thickness, y, color,
                      x, y + height, color,
                      x + thickness, y + height, color, 11
    elsif @active_side == :right
      Gosu::draw_quad x + width - thickness, y, color,
                      x + width, y, color,
                      x + width - thickness, y + height, color,
                      x + width, y + height, color, 11
    end
  end
  
  def activate_portal(side, color)
    @active_side = side
    @portal_color = color
  end
  
  def deactivate_portal
    @active_side = nil
  end
  
  def portal_active?
    not @active_side.nil?
  end
  
  def collides?(other)
    if other.x + other.width <= x ||            # left
      other.x                >= x + width ||    # right
      other.y + other.height <= y ||            # top
      other.y                >= y + height      # bottom
      
      return false
    end
    
    return :left if other.previous_x + other.width <= x and other.x + other.width > x
    return :right if other.previous_x >= x + width and other.x < x + width
    return :top if other.previous_y + other.height <= y and other.y + other.height > y
    return :bottom if other.previous_y >= y + height and other.y < y + height
    
    return :old
  end
end