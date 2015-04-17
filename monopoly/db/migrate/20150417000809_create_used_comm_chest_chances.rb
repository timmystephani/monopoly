class CreateUsedCommChestChances < ActiveRecord::Migration
  def change
    create_table :used_comm_chest_chances do |t|
      t.integer :card_index
      t.references :game, index: true, foreign_key: true
      t.integer :card_type, default: 0

      t.timestamps null: false
    end
  end
end
