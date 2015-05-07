class AddDiceToGame < ActiveRecord::Migration
  def change
    add_column :games, :die1, :integer, default: 1, null: false
    add_column :games, :die2, :integer, default: 1, null: false
  end
end
