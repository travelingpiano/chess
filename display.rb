require "colorize"
require_relative "board"
require_relative "cursor"

class Display
  attr_accessor :cursor, :board
  def initialize(board)
    @cursor = Cursor.new([0,0],board)
    @board = board
  end

  def render
    fg_color = :blue
    bg_color = :white
    symbol = ""
    8.times do |x|
      puts
      8.times do |y|
        if (x+y).even?
          bg_color = :gray
        else
          bg_color = :white
        end
        if cursor.cursor_pos == [x,y]
          bg_color = :green
        end
        if board[[x,y]].is_a?(NullPiece)
          symbol = "   "
        else
          symbol = "\u2654"
          symbol = " " + symbol.encode('utf-8') + " "
          fg_color = :blue
        end
        print symbol.colorize(:color => fg_color, :background => bg_color)
      end
    end
  end

end

b = Board.new
d = Display.new(b)
while true
  d.render
  d.cursor.get_input
  system("clear")
end
