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
require "test_helper"

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
