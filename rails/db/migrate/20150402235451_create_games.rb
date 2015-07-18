class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :current_player_id
      t.string :status
      t.integer :free_parking_pot

      t.timestamps null: false
    end
  end
end
