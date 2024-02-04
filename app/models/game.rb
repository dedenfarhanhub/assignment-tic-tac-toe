# == Schema Information
#
# Table name: games
#
#  id                 :integer          not null, primary key
#  player1_session_id :string
#  player1_name       :string
#  player2_session_id :string
#  player2_name       :string
#  current_player     :string
#  current_symbol     :string
#  board              :json
#  winner             :string
#  status             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Game < ApplicationRecord
  serialize :board, Array

  WINNING_COMBINATIONS = [
    [[0, 0], [0, 1], [0, 2]],
    [[1, 0], [1, 1], [1, 2]],
    [[2, 0], [2, 1], [2, 2]],
    [[0, 0], [1, 0], [2, 0]],
    [[0, 1], [1, 1], [2, 1]],
    [[0, 2], [1, 2], [2, 2]],
    [[0, 0], [1, 1], [2, 2]],
    [[0, 2], [1, 1], [2, 0]]
  ].freeze

  enum status: {
    pending: 0,
    on_progress: 1,
    completed: 2
  }

  scope :waiting_opponent, lambda { |player_session_id|
    pending.where(player2_session_id: nil)
           .where.not(player1_session_id: player_session_id)
  }

  scope :by_owner, lambda { |player_session_id|
    where(player1_session_id: player_session_id)
      .or(where(player2_session_id: player_session_id))
  }

  def initialize_game!(current_user)
    Game.find_or_create_by(
      player1_session_id: current_user['player_session_id'],
      player1_name: current_user['nickname'],
      current_player: current_user['player_session_id'],
      current_symbol: 'X',
      board: Array.new(3) { Array.new(3) },
      status: :pending
    )
  end

  def join_game!(current_user)
    return false if on_progress? || completed? # Cannot join a game in progress or completed

    update(
      player2_session_id: current_user['player_session_id'],
      player2_name: current_user['nickname'],
      status: :on_progress
    )
    self
  end

  def player_info(name, symbol)
    name ? "#{name} (#{symbol})" : 'Waiting...'
  end

  def player_role_label_x(player_session_id)
    player1_session_id == player_session_id ? 'You' : 'Opponent'
  end

  def player_role_label_o(player_session_id)
    player2_session_id == player_session_id ? 'You' : 'Opponent'
  end

  def turn_you?(player_session_id)
    current_player == player_session_id
  end

  def cell_already_marked?(row, col)
    board[row][col].present?
  end

  def game_already_ended?
    completed?
  end

  def board_full?
    board.flatten.all?(&:present?)
  end

  def make_move!(row, col)
    board[row][col] = current_symbol
    self.current_player, self.current_symbol = player_turn_swap
    self.winner = check_game_result
    self.status = :completed if winner.present?
    save!
    self
  end

  def check_game_result
    return player1_session_id if check_winner('X')
    return player2_session_id if check_winner('O')
    return 'draw' if board_full?

    nil
  end

  def check_winner(symbol)
    WINNING_COMBINATIONS.any? { |combination| combination.all? { |pos| board[pos[0]][pos[1]] == symbol } }
  end

  def player_turn_swap
    [player_turn_opponent, (current_symbol == 'X' ? 'O' : 'X')]
  end

  def player_turn_opponent
    current_player == player1_session_id ? player2_session_id : player1_session_id
  end

  def board_selected(row, col)
    {
      row: row,
      col: col,
      cell_value: (current_symbol == 'X' ? 'O' : 'X')
    }
  end

  def end_turn!(player_session_id)
    self.status = :completed
    self.winner = player1_session_id == player_session_id ? player2_session_id : player1_session_id
    save!
    self
  end
end
