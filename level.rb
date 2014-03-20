require_relative 'block'

class Level
  attr_reader :width, :height, :blocks
  
  def initialize(name)
    lines = File.readlines "levels/#{name}.txt"
    
    @width = lines.max_by { |line| line.length }.length * 64
    @height = lines.size * 64
    
    @blocks = []
    lines.each_with_index do |line, y_index|
        
        line.split('').each_with_index do |character, x_index|
          if character == 'x'
            @blocks << Block.new(x_index * 64, y_index * 64)
          end
          
        end
      
    end
    
  end
  
  def draw
    @blocks.each { |block| block.draw }
  end
end