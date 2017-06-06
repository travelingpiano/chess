require "byebug"

class Board
attr_accessor = :grid
  def initialize
    @grid = [[],[],[],[],[],[],[],[]]
    build_grid
  end

  def build_grid
    @grid[0][0]= Rook.new([0,0],self)
    @grid[0][1]= Knight.new([0,1],self)
    @grid[0][2]= Bishop.new([0.2],self)
    @grid[0][3]= Queen.new([0,3],self)
    @grid[0][4]= King.new([0,4],self)
    @grid[0][5]= Bishop.new([0,5],self)
    @grid[0][6]= Knight.new([0,6],self)
    @grid[0][7]= Rook.new([0,7],self)

    8.times do |idx|
      @grid[1][idx] = Pawn.new([1,idx],self)
      @grid[6][idx] = Pawn.new([6,idx],self)
      (2..5).each do |idx2|
        @grid[idx2][idx] = NullPiece.new([idx2,idx],self)
      end
    end

    @grid[7][0]= Rook.new([7,0],self)
    @grid[7][1]= Knight.new([7,1],self)
    @grid[7][2]= Bishop.new([7.2],self)
    @grid[7][3]= Queen.new([7,3],self)
    @grid[7][4]= King.new([7,4],self)
    @grid[7][5]= Bishop.new([7,5],self)
    @grid[7][6]= Knight.new([7,6],self)
    @grid[7][7]= Rook.new([7,7],self)
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

end


class Piece
  attr_accessor :pos, :board

  def initialize(pos,board)
    @pos = pos
    @board = board
  end

end

module SlidingPiece

  def moves(dirs,pos,board)
    arr = []
    case dirs
    when :d #diagonally
    when :h #horizontally/vertically
      x = pos[0]+1
      y = pos[1]
      #debugger
      #right direction
      while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
        arr << [x,y]
        x += 1
      end
      arr << [x,y] if board.in_bounds([x,y])
      #left direction
      x = pos[0]-1
      while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
        arr << [x,y]
        x -= 1
      end
      arr << [x,y] if board.in_bounds([x,y])
      #up direction
      x = pos[0]
      y = pos[1]-1
      while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
        arr << [x,y]
        y -= 1
      end
      arr << [x,y] if board.in_bounds([x,y])
      #down direction
      y = pos[1]+1
      while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
        arr << [x,y]
        y += 1
      end
      arr << [x,y] if board.in_bounds([x,y])
    when :b #both
    end
    arr
  end
end

class Rook < Piece
  include SlidingPiece
  attr_accessor :dirs
  def initialize(pos,board)
    @dirs = :h
    super
  end
end

class King < Piece
end

class Pawn < Piece
end

class Knight < Piece
end

class Queen < Piece
end

class Bishop < Piece
end

class NullPiece < Piece
end



 b = Board.new
 p b[[0,0]].moves(:h,[0,0],b)
# b.move_piece([0,1],[2,0])
# p b[[0,1]]
# p b[[2,0]]
# p b[[2,0]].pos
# b.move_piece([4,4],[1,1])
