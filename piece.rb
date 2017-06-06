class Piece
  attr_accessor :pos, :board, :name

  def initialize(pos,board,player_name)
    @pos = pos
    @board = board
    @name = player_name
  end

end

module SteppingPiece
  KNIGHT_MOVES = [[2,1],
                  [1,2],
                  [-1,-2],
                  [-2,-1],
                  [-1,2],
                  [-2,1],
                  [2,-1],
                  [1,-2]]
  KING_MOVES = [[1,1],
                [1,0],
                [1,-1],
                [0,1],
                [0,-1],
                [-1,1],
                [-1,0],
                [-1,-1]]
  def moves(pos,board,player_name)
    pos_comb = []
    if board[pos].is_a?(King)
      pos_comb = KING_MOVES
    else
      pos_comb = KNIGHT_MOVES
    end
    new_pos = []
    pos_positions = []
    pos_comb.each do |delta|
      new_pos = [delta[0]+pos[0],delta[1]+pos[1]]
      if board.in_bounds(new_pos) && board[new_pos].name != player_name
        pos_positions << new_pos
      end
    end
    pos_positions
  end
end

module SlidingPiece

  def moves(dirs,pos,board,player_name)
    arr = []
    case dirs
    when :d #diagonally
      arr = diagonal_moves(pos,board,player_name)
    when :h #horizontally/vertically
      arr = horizontal_moves(pos,board,player_name)
    when :b #both
      arr = diagonal_moves(pos,board,player_name)
      arr += horizontal_moves(pos,board,player_name)
    end
    arr
  end

  def horizontal_moves(pos,board,player_name)
    x = pos[0]+1
    y = pos[1]
    #debugger
    arr = []
    #right direction
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      x += 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #left direction
    x = pos[0]-1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      x -= 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #up direction
    x = pos[0]
    y = pos[1]-1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      y -= 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #down direction
    y = pos[1]+1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      y += 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
  end

  def diagonal_moves(pos,board,player_name)
    x = pos[0]+1
    y = pos[1]+1
    #debugger
    arr = []
    #+1,+1 direction
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      x += 1
      y += 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #+1, -1 direction
    x = pos[0]+1
    y = pos[1]-1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      x += 1
      y -= 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #-1,+1 direction
    x = pos[0]-1
    y = pos[1]+1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      y += 1
      x -= 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
    #-1,-1 direction
    x = pos[0]-1
    y = pos[1]-1
    while board[[x,y]].is_a?(NullPiece) && board.in_bounds([x,y])
      arr << [x,y]
      x -= 1
      y -= 1
    end
    arr << [x,y] if board.in_bounds([x,y]) && board[[x,y]].name != player_name
  end

end

class Rook < Piece
  include SlidingPiece
  attr_accessor :dirs
  def initialize(pos,board,player_name)
    @dirs = :h
    super
  end
end

class King < Piece
  include SteppingPiece
end

class Pawn < Piece
  def moves
    new_positions = []
    new_pos = []
    if name == "player1"
      delta = 1
    else
      delta = -1
    end
    new_pos = [pos[0]+delta,pos[1]]
    if board.in_bounds(new_pos) && board[new_pos].is_a?(NullPiece)
      new_positions << new_pos
    end
    new_pos = [[pos[0]+delta,pos[1]+1],[pos[0]+delta,pos[1]-1]]
    if board[new_pos[0]].name != name && board[new_pos[0]].name
      new_positions << new_pos[0]
    end
    if board[new_pos[1]].name != name && board[new_pos[1]].name
      new_positions << new_pos[1]
    end
    new_pos = [pos[0]+delta+delta,pos[1]]
    if name == "player1" && pos[0]==1 && board[new_pos].is_a?(NullPiece) \
       && board[[pos[0]+delta,pos[1]]].is_a?(NullPiece)
      new_positions << new_pos
    end
    if name == "player2" && pos[0]==6 && board[new_pos].is_a?(NullPiece) \
       && board[[pos[0]+delta,pos[1]]].is_a?(NullPiece)
      new_positions << new_pos
    end
    new_positions
  end
end

class Knight < Piece
  include SteppingPiece
end

class Queen < Piece
  include SlidingPiece
end

class Bishop < Piece
  include SlidingPiece
end

class NullPiece < Piece
  include Singleton
  def initialize
  end
end
