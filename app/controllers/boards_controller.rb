class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :update, :destroy, :play]
  before_action :set_current_user, only: [:joingame, :play, :create]
  # GET /boards
  
  def index
    boards = Board.all
    render json: boards
  end

  # GET /boards/1
  def show
    render json: board, status: :ok
  end

  # POST /boards
  def create
    board = Board.new
    board.initialize_board(current_user)
    
    board.save
    if board.save
      render json: board, status: :created, location: board
    else
      render json: board.errors, status: :unprocessable_entity
    end
  end

  
  #Agregar contrincante
  def joingame

    board.join_game(current_user)
    board.save
    if board.save
      render json: board.users, status: :created
    else
      render json: board.errors, status: :unprocessable_entity
    end
  end

  #Definir jugada ##FALTA AGREGAR RUTA
  def play
    
    # Validar si es el turno
    if board.valid_turn?(current_user)
    else
      return render(json: {error: "This is not your turn."}, status: :unprocessable_entity)
    end
    # Validar si se puede poner en ese lugar, desde el front ya deberia no dejarlo, pero igual lo hago acá
    if board.valid_place?(params[:index])
    else
      return render(json: {error: "This place is not available"}, status: :unprocessable_entity)
    end
    
    # Hacer movimiento
    board.insert_in(params[:index],current_user)

    # Verificar si gano y si no gano que cambie el estado para que le toque al otro
    if board.winner?(current_user)
      board.set_winner(current_user)
    else
      board.set_turn
    end
    board.save
      return render(json: board, status: :ok)
  end


  private

  # Use callbacks to share common setup or constraints between actions.
    def set_board
      board = Board.find(params[:id])
    end

    def set_current_user
      current_user = User.find_by(id: params[:user_id].to_i)
    end

end
