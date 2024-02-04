# frozen_string_literal: true

class GamesController < ApplicationController
  skip_before_action :authentic_client!, only: %i[index]
  before_action :prepare_game, only: %i[show move end_turn reset]

  def index; end

  def create
    @game = find_or_create_game
    redirect_to @game
  end

  def show; end

  def move
    handle_move_request
  end

  def end_turn
    handle_end_turn_request
  end

  def reset
    handle_reset_request
  end

  private

  def game
    @game ||= Game.by_owner(@current_user['player_session_id']).find_by(id: params[:id])
  end

  def prepare_game
    return redirect_to games_path if game.blank?

    @game = game
  end

  def find_or_create_game
    game_waiting_opponent = Game.waiting_opponent(@current_user['player_session_id']).first

    if game_waiting_opponent.blank?
      Game.new.initialize_game!(@current_user)
    else
      saved_game = game_waiting_opponent.join_game!(@current_user)
      broadcast_opponent_join(saved_game)
      saved_game
    end
  end

  def handle_move_request
    row = params[:row].to_i
    col = params[:col].to_i

    return render_invalid('The game has already ended') if @game.game_already_ended?
    return render_invalid('Cell already marked') if @game.cell_already_marked?(row, col)
    unless @game.turn_you?(@current_user['player_session_id'])
      return render_invalid('It\'s not your turn to mark this cell')
    end

    make_move!(row, col)
  end

  def handle_end_turn_request
    return render_invalid('The game has already ended') if @game.game_already_ended?

    state_end_turn!
    render json: { success: true }
  end

  def handle_reset_request
    state_end_turn! unless @game.game_already_ended?
    reset_session
    render json: { success: true }
  end

  def make_move!(row, col)
    @game = @game.make_move!(row, col)
    broadcast_move(row, col, @game)
    render json: { success: true }
  end

  def state_end_turn!
    @game = @game.end_turn!(@current_user['player_session_id'])
    broadcast_end_turn(@game)
  end

  def broadcast_move(row, col, game)
    ActionCable.server.broadcast("games_channel_#{params[:id]}", build_message_move(row, col, game))
  end

  def broadcast_end_turn(game)
    ActionCable.server.broadcast("games_channel_#{params[:id]}", build_message_end_turn(game))
  end

  def broadcast_opponent_join(game)
    ActionCable.server.broadcast("games_channel_#{game.id}", { game: game, opponent_join: true })
  end

  def render_invalid(error_message)
    render json: { success: false, error: error_message }, status: :unprocessable_entity
  end

  def build_message_move(row, col, game)
    {
      game: game,
      board_selected: game.board_selected(row, col),
      game_already_ended: game.completed?
    }
  end

  def build_message_end_turn(game)
    {
      game: game,
      game_already_ended: game.completed?
    }
  end
end
