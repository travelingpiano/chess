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
    8.times do |x|
      puts
      8.times do |y|
        if board[[x,y]]
          mark = "\u2654"
          mark = mark.encode('utf-8')
          if cursor.cursor_pos == [x,y]
            print mark.green + " "
          else
            print mark + " "
          end
        else
          empty = "\u2610"
          empty = empty.encode('utf-8')
          if cursor.cursor_pos == [x,y]
            print empty.green + " "
          else
            print empty + " "
          end
        end
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
