class Board < ApplicationRecord #Darle uso a la tabla intermedia guardando el estado general 
    has_and_belongs_to_many :users, join_table: "users_boards"
    serialize :table

    def initialize_board(current_user)
        self.table = {}
        self.state = "Queue"
        self.turn = 'X'
        self.users.push(current_user)
    end

    def join_game(current_user)
        self.users.push(current_user)
        self.state = 'Playing'
    end


    def userPiece(user)
        self.users.index(user) == 0 ? 'X' : 'O'
    end
    

    def insert_in(index,current_user)
        index = index.to_i
        self.table[index] = turn
    end


    def winner?(current_user) ## Ver la manera de hacerlo mucho más simple, array ordenado por user
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

            if position - positionsturn == []
                
                return true
            end
        end    
        return false
    end

    def draw?
        self.table.length == 9
    end
    

    def set_winner(current_user)
        self.winner = current_user.name
        self.state = 'Finished'
    end


    def set_draw
        self.state = 'Draw'
    end
    
    def set_turn
        other = self.turn == "X" ? 'O' : 'X' 
        self.turn = other
    end

    def set_myTurn(current_user)
        turn = valid_turn?(current_user)
        self.myTurn = turn
    end 

    #Verifico si le corresponde el turno.
    def valid_turn?(current_user)
        myPiece = userPiece(current_user)
        self.turn == myPiece
    end

    #Verifico que este vacio para poner la pieza y si es un número válido.
    def valid_place?(index)    
        index = index.to_i
        self.table[index] == nil && index >= 0 && index <9
    end


    def can_join?(current_user)
        self.users.include?(current_user) ? false : self.users.count == 1
    end
end
