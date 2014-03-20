class Bullet
  attr_reader :color, :x, :y, :previous_x, :previous_y
  
  def initialize(x, y, target_x, target_y, color)
    @x = x
    @y = y
    
    @angle = Gosu::angle x, y, target_x, target_y
    
    @color = color
    
    @images = Gosu::Image.load_tiles "images/bullet_#{color}.png", 32, 32
    @animation_index = 0
  end
  
  def width
    @images[0].width
  end
  
  def height
    @images[0].height
  end
  
  def update
    @previous_x, @previous_y = @x, @y
    velocity = 8
    
    @x += Gosu::offset_x @angle, velocity
    @y += Gosu::offset_y @angle, velocity
  end
  
  def draw
    @animation_index += 1
    @images[@animation_index % @images.size].draw @x, @y, 5
  end
end