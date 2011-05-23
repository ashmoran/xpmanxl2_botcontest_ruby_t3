class Bot
  def initialize(input, output)
    @input = input
    @output = output
    @output.sync = true
    @brain = Brain.new
  end
  
  class Memory
    def initialize
      @opponent_moves = [ ]
      @our_moves = [ ]      
    end

    def opponent_has_moved_in_row?(row)
      @opponent_moves.detect { |move| move =~ /^#{row}/ }
    end

    def number_opponent_moves_in_row(row)
      @opponent_moves.count { |move| move =~ /^#{row}/ }
    end

    def free_move_in_row(row)
      move = nil
      (0..2).detect { |i| move = available?("#{row}#{i}") }
      move
    end

    def available?(move)
      if known_moves.include?(move)
        false
      else
        move
      end
    end

    def known_moves
      @opponent_moves + @our_moves
    end

    def remember_opponent_move(move)
      @opponent_moves << move
    end

    def remember_our_move(move)
      @our_moves << move
    end
  end
  
  class Brain
    def initialize
      @count = 0
      @current_row = "C"
      @memory = Memory.new
    end

    def see_opponent_move(grid_ref)
      @memory.remember_opponent_move(grid_ref)
      
      if grid_ref =~ /^C/
        @current_row = "B"
      end
    end

    def move
      @count = 0 if @count == 3
      move = get_move
      if @memory.available?(move)
        @count += 1
        @memory.remember_our_move(move)
        move
      else
        change_row
        move = "#{@current_row}#{@count}"
        @count += 1
        @memory.remember_our_move(move)
        move
      end
    end

    def get_move
      if row = opponent_has_two_in_one_row?
        @memory.free_move_in_row(row)
      else
        "#{@current_row}#{@count}"
      end
    end

    private

    def opponent_has_two_in_one_row?
      if @memory.number_opponent_moves_in_row("C") == 2
        "C"
      elsif @memory.number_opponent_moves_in_row("B") == 2
        "B"
      elsif @memory.number_opponent_moves_in_row("A") == 2
        "A"
      end
    end

    def change_row
      if @memory.opponent_has_moved_in_row?("A")
        @current_row = "B"
      else
        @current_row = "A"
      end
      @count = 0
    end
  end

  def run
    @moves_left = 4

    loop do
      opponent_move = @input.gets.chomp

      if opponent_move == ""
        @moves_left += 1
      else
        @brain.see_opponent_move(opponent_move)
      end

      @output.puts @brain.move

      @moves_left -= 1
      break if @moves_left == 0
    end
  end
end