class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :name
      t.string :token
      t.integer :cash
      t.boolean :in_jail
      t.integer :jail_rolls
      t.integer :position

      t.timestamps null: false
    end
  end
end
