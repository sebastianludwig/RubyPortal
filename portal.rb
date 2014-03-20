require 'gosu'
require 'gosu/preview'

require_relative 'level'
require_relative 'player'
require_relative 'bullet'

class PortalWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = 'Portal'
    
    @level = Level.new '1'
    @player = Player.new 70, 120, @level
    @bullets = []
  end
  
  def update
    super
    @player.update
    @bullets.each { |bullet| bullet.update }
    
    @level.blocks.each do |block|
      @bullets.reject! do |bullet| 
        collision_side = block.collides? bullet
        
        block.activate_portal(collision_side, bullet.color) if collision_side
        
        collision_side
      end
    end
  end
  
  def draw
    super
    @level.draw
    @player.draw
    @bullets.each { |bullet| bullet.draw }
  end
  
  def button_down(key)
    close if key == Gosu::KbEscape
    
    if key == Gosu::MsLeft or key == Gosu::MsRight
      color = key == Gosu::MsLeft ? :blue : :orange
      
      @bullets.reject! { |bullet| bullet.color == color }
      
      @level.blocks.each { |block| block.deactivate_portal if block.portal_active? and block.portal_color == color }
      
      @bullets << Bullet.new(@player.x, @player.y, mouse_x, mouse_y, color)
    end
  end
  
  def needs_cursor?
    true
  end
end

portal_window = PortalWindow.new
portal_window.show
