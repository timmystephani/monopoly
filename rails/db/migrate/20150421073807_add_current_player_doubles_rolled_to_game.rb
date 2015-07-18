class AddCurrentPlayerDoublesRolledToGame < ActiveRecord::Migration
  def change
    add_column :games, :current_player_doubles_rolled, :integer, default: 0
  end
end
