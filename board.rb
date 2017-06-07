require "byebug"
require "singleton"
require_relative "piece"

class Board
attr_accessor = :grid
  def initialize
    @grid = [[],[],[],[],[],[],[],[]]
    build_grid
  end

  def build_grid
    @grid[0][0]= Rook.new([0,0],self,"player1")
    @grid[0][1]= Knight.new([0,1],self,"player1")
    @grid[0][2]= Bishop.new([0.2],self,"player1")
    @grid[0][3]= Queen.new([0,3],self,"player1")
    @grid[0][4]= King.new([0,4],self,"player1")
    @grid[0][5]= Bishop.new([0,5],self,"player1")
    @grid[0][6]= Knight.new([0,6],self,"player1")
    @grid[0][7]= Rook.new([0,7],self,"player1")

    8.times do |idx|
      @grid[1][idx] = Pawn.new([1,idx],self,"player1")
      @grid[6][idx] = Pawn.new([6,idx],self,"player2")
      (2..5).each do |idx2|
        @grid[idx2][idx] = NullPiece.instance
      end
    end

    @grid[7][0]= Rook.new([7,0],self,"player2")
    @grid[7][1]= Knight.new([7,1],self,"player2")
    @grid[7][2]= Bishop.new([7.2],self,"player2")
    @grid[7][3]= Queen.new([7,3],self,"player2")
    # @grid[7][4]= King.new([7,4],self,"player2")
    @grid[3][4]= King.new([3,4],self,"player2")
    @grid[7][4]= NullPiece.instance
    @grid[7][5]= Bishop.new([7,5],self,"player2")
    @grid[7][6]= Knight.new([7,6],self,"player2")
    @grid[7][7]= Rook.new([7,7],self,"player2")
  end

  def []((x,y))
    @grid[x][y]
  end

  def []=((x,y),value)
    @grid[x][y]=value
  end

  def move_piece(start_pos,end_pos)
    position_array = start_pos+end_pos
    unless in_bounds(position_array)
      raise ArgumentError
    end
    unless self[start_pos] == nil && self[end_pos] != nil
      self[start_pos].pos = end_pos
      self[end_pos] = self[start_pos]
      self[start_pos] = nil
    else
      raise ArgumentError
    end
  end

  def in_bounds(position)
    return true if position.all?{|pos| pos >= 0 && pos < 8}
    false
  end

  def in_check?(player_name)
    king_pos = []
    8.times do |idx|
      8.times do |idx2|
        if self[[idx,idx2]].name == player_name && self[[idx,idx2]].is_a?(King)
          king_pos = [idx,idx2]
        end
      end
    end
    opp_player = ""
    if player_name == "player1"
      opp_player = "player2"
    else
      opp_player = "player1"
    end
    8.times do |idx|
      8.times do |idx2|
        if self[[idx,idx2]].name == opp_player
          pos_moves = self[[idx,idx2]].moves(nil,[idx,idx2],self,opp_player)
          return true if pos_moves.include?(king_pos)
        end
      end
    end
    false
  end

  def dup
    new_board = Board.new
    8.times do |idx|
      8.times do |idx2|
        if self[[idx,idx2]].is_a?(NullPiece)
          new_board[[idx,idx2]] = NullPiece.instance
        else
          player = self[[idx,idx2]].name
          piece_class = self[[idx,idx2]].class
          new_board[[idx,idx2]] = piece_class.new([idx,idx2],new_board,player)
        end
      end
    end
    new_board
  end

end

 b = Board.new
 p b[[7,1]].class.to_s
 # p b[[0,0]].moves(:h,[0,0],b,"player1") #test rook
 # p b[[0,1]].moves([0,1],b,"player1")  #test knight
 # p b[[0,2]].moves(:d,[0,2],b,"player1") #test bishop
 # p b[[0,3]].moves(:d,[0,3],b,"player1") #test king
 # p b[[1,1]].moves #test pawn

 # p b.in_check?("player1")
 # b.duplicate
# b.move_piece([0,1],[2,0])
# p b[[0,1]]
# p b[[2,0]]
# p b[[2,0]].pos
# b.move_piece([4,4],[1,1])
