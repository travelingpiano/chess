require "colorize"
require_relative "board"
require_relative "piece"
require_relative "cursor"
require "byebug"

class Display
  attr_accessor :cursor, :board

  SYMBOLS = {"Knight" => "\u2658",
            "King" => "\u2654",
            "Queen" => "\u2655",
            "Rook" => "\u2656",
            "Bishop" => "\u2657",
            "Pawn" => "\u2659"}

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
          symbol = Display::SYMBOLS[board[[x,y]].class.to_s]
          symbol = " " + symbol.encode('utf-8') + " "
          if board[[x,y]].name == "player1"
            fg_color = :blue
          else
            fg_color = :black
          end
        end
        print symbol.colorize(:color => fg_color, :background => bg_color)
      end
    end
  end

end

b = Board.new
d = Display.new(b)
toggle = 0
start_pos = []
end_pos = []
selected_piece = []
while true
  d.render
  current_pos = d.cursor.get_input
  p start_pos
  p toggle
  if current_pos
    if toggle%2 == 0
      start_pos = current_pos
      selected_piece = b[start_pos]
      toggle = 1 if selected_piece.class == NullPiece
    else
      end_pos = current_pos
      if selected_piece.valid_moves.include?(end_pos)
        player = selected_piece.name
        piece_class = selected_piece.class

        b[end_pos] = piece_class.new(end_pos,b,player)
        start_pos = selected_piece.pos
        b[start_pos] = NullPiece.instance
      end
    end
    toggle += 1
    toggle = toggle%2
  end

  system("clear")
end
