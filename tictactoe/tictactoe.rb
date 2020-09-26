def print_board board

    board.each_with_index {|item, index|
        
        if (index) % 3 == 0
            #print index
            print "\n|"
        end 
        print item + "|" 
    }

    print "\n"
    
end

def game_loop

    board = Array.new(9, "-")

    moves = 0

    print_board(board)

    x_turn = true

    while moves < 9 do

        if moves.even? 
            puts "x's turn. Put in an integer between 1 and 9"
            x_turn = true
        else 
            puts "y's turn. Put in an integer between 1 and 9"
            x_turn = false
        end

        i = gets.to_i

        while !i.between?(1,10) do
            puts "Please put in an integer between 1 and 9"

            i = gets.to_i
        end

        #i -= 1 # translate input number to index

        while board[i-1] != "-" do
            puts "Field #{i} is already taken. Please put in another number"

            i = gets.to_i
        end


        x_turn ? board[i-1] = "x" : board[i-1] = "o"

        print_board(board)

        moves += 1

        if check_if_won(board)
            break
        end

    end

    if x_turn && moves < 9
        puts "X Won!"
    elsif !x_turn
        puts "Y Won!"
    else 
        puts "Draw!"
    end

    puts "Play again? Y/N"

    answer = gets.chomp.upcase

    if answer == "Y"
        game_loop
    end

end

def check_if_won board

    if board[0] != "-" && board[0] == board[1] && board[1] == board[2] ||
       board[3] != "-" && board[3] == board[4] && board[4] == board[5] ||
       board[6] != "-" && board[6] == board[7] && board[7] == board[8] ||
       board[0] != "-" && board[0] == board[3] && board[3] == board[6] ||
       board[1] != "-" && board[1] == board[4] && board[4] == board[7] ||
       board[2] != "-" && board[2] == board[5] && board[5] == board[8] ||
       board[0] != "-" && board[0] == board[4] && board[4] == board[8] ||
       board[2] != "-" && board[2] == board[4] && board[4] == board[6]
       return true
    end
end

game_loop