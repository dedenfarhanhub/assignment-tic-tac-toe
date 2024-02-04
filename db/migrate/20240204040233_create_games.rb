class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :player1_session_id, index: true
      t.string :player1_name
      t.string :player2_session_id, index: true
      t.string :player2_name
      t.string :current_player
      t.string :current_symbol
      t.json :board, default: []
      t.string :winner
      t.integer :status
      t.timestamps
    end
  end
end
