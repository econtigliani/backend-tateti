class BoardsController < ApplicationController
  before_action :current_board, only: %i[joingame show update destroy play ]
  before_action :check_token, only: %i[joingame play create]

  # GET /boards

  def index
    boards = Board.all
    render json: boards
  end

  # GET /boards/1
  def show
    
    if current_board.users.length == 2
      if current_board.state == 'Playing'
          current_board.set_myTurn(current_user)
      else
        current_board.myTurn = false
      end
    
      return render(json: {board: current_board, X: current_board.users[0].name, O:current_board.users[1].name}, status: :ok)
    else
      return render(json: {board: current_board, X: current_board.users[0].name, O:null}, status: :ok)
    end
  end

  # POST /boards
  def create
    board = Board.new
    board.initialize_board(current_user)

    board.save
    if board.save
      render json: {id: board.id, state: board.state}, status: :created, location: board
    else
      render json: format_error(request.path, board.errors.full_messages), status: :unprocessable_entity
    end
  end

  #Agregar contrincante
  def joingame

    if current_board.can_join?(current_user)

    else
      return(
        render(
          json: {
            error: 'This game already have two players',
          },
          status: :unprocessable_entity,
        )
      )
    end

    current_board.join_game(current_user)

    current_board.save
    if current_board.save
      render json: {id: current_board.id, state: current_board.state} , status: :ok
    else
      render json: format_error(request.path, current_board.errors.full_messages), status: :unprocessable_entity
    end
  end

  #Definir jugada
  def play
    # Validar si es el turno
    if current_board.valid_turn?(current_user)

    else
      return(
        render(
          json: {
            error: 'This is not your turn.',
          },
          status: :unprocessable_entity,
        )
      )
    end

    # Validar si se puede poner en ese lugar, desde el front ya deberia no dejarlo, pero igual lo hago acá
    if current_board.valid_place?(params[:index])

    else
      return(
        render(
          json: {
            error: 'This place is not available',
          },
          status: :unprocessable_entity,
        )
      )
    end

    # Hacer movimiento
    current_board.insert_in(params[:index], current_user)

    # Verificar si gano y si no gano que cambie el estado para que le toque al otro
    if current_board.winner?(current_user)
      current_board.set_winner(current_user)
    else
      if current_board.draw?
        current_board.set_draw
      else
        current_board.set_turn
        current_board.set_myTurn(current_user)
      end
    end
    current_board.save
    return render(json: {board: current_board, X: current_board.users[0].login, O:current_board.users[1].login}, status: :ok)
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def current_board
    @board ||= Board.find(params[:id])
  end

end
