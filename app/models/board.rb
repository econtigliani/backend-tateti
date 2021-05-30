class Board < ApplicationRecord
    has_and_belongs_to_many :users, join_table: "users_boards"
    serialize :table

    def initialize_board(current_user)
        self.table = {}
        self.state = "X"
        self.users.push(current_user)
    end

    def join_game(current_user)
        self.users.push(current_user)
    end


    def userPiece(user)
        if self.users.index(user) == 0
            return 'X'
        elsif self.users.index(user) == 1
            return 'O'
        end
    end
    

    def insert_in(index,current_user)
        turn = userPiece(current_user)
        index = index.to_i
        self.table[index] = turn
    end


    def winner?(current_user)
        turn = userPiece(current_user)
        
        positionsturn = []
        self.table.each do |key,value|
            if value == turn
                positionsturn.push(key)
            end          
        end

        winningPositions = [
            [0,1,2],
            [3,4,5],
            [6,7,8],
            [0,3,6],
            [1,4,7],
            [2,5,8],
            [0,4,8],
            [2,4,6],
          ]
          
        for position in winningPositions do
            if positionsturn.include?(position[0]) && positionsturn.include?(position[1]) && positionsturn.include?(position[2])
                return true
            end
        end    
        return false
    end


    def set_winner(current_user)
        turn = userPiece(current_user)
        self.state = 'Winner_' + turn
    end

    
    def set_turn
        if self.state == 'X'
            self.state = 'O'
        elsif self.state == 'O'
            self.state = 'X'
        end
    end
    
    #Verifico si le corresponde el turno.
    def valid_turn?(current_user)
        turn = userPiece(current_user)
        self.state == (turn)
    end

    #Verifico que este vacio para poner la pieza y si es un número válido.
    def valid_place?(index)    
        index = index.to_i
        self.table[index] == nil && index >= 0 && index <=8
    end

end
