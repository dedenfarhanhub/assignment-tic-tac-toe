# frozen_string_literal: true

require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    post sessions_url, params: { user: { nickname: 'Player 1' } }

    follow_redirect!
    # Now @current_user is set based on the session
    @current_user = session[:current_user]
    @game = Game.new.initialize_game!(@current_user)
    @game.join_game!(@current_user)
  end

  test 'should create a new game' do
    post games_url, params: {}
    assert_redirected_to game_url(Game.last)
  end

  test 'should show the index' do
    get games_url
    assert_response :success
  end

  test 'should find or create game - join existing game' do
    @game.update(status: 0, player2_session_id: nil)
    post sessions_url, params: { user: { nickname: 'Player 1' } }

    follow_redirect!
    post games_url, params: {}
    assert_redirected_to game_url(Game.last)
  end

  test 'should show the game' do
    get game_url(@game)
    assert_response :success
  end

  test 'should make move' do
    post move_game_url(@game), params: { row: 0, col: 0 }
    assert_response :success
    assert_equal 'X', @game.reload.board[0][0]
  end

  test 'should end game with winner X' do
    perform_moves([[0, 0], [1, 1], [0, 1], [2, 2], [0, 2]])
    assert_equal @game.player1_session_id, @game.reload.winner
  end

  test 'should handle move when game is already ended' do
    @game.update(status: 2, winner: 'X')
    post move_game_url(@game), params: { row: 1, col: 1 }
    assert_response :unprocessable_entity
    assert_equal 'The game has already ended', JSON.parse(response.body)['error']
  end

  test 'should handle move to already marked cell' do
    post move_game_url(@game), params: { row: 0, col: 0 }
    post move_game_url(@game), params: { row: 0, col: 0 }
    assert_response :unprocessable_entity
    assert_equal 'Cell already marked', JSON.parse(response.body)['error']
  end

  test 'should handle move when it\'s not your turn' do
    opponent_user = { 'player_session_id' => 'player_2', 'nickname' => 'Player 2' }
    @game.update(current_player: opponent_user['player_session_id'])
    post move_game_url(@game), params: { row: 1, col: 1 }
    assert_response :unprocessable_entity
    assert_equal 'It\'s not your turn to mark this cell', JSON.parse(response.body)['error']
  end

  test 'should end turn' do
    post end_turn_game_url(@game)
    assert_response :success
    assert_equal @game.player2_session_id, @game.reload.current_player
  end

  test 'should reset game' do
    post reset_game_url(@game)
    assert_response :success
    assert_equal @game.player2_session_id, @game.reload.winner
    assert_equal 'completed', @game.reload.status
  end

  private

  def perform_moves(moves)
    moves.each do |move|
      post move_game_url(@game, row: move[0], col: move[1])
    end
    @game.reload
  end

end
