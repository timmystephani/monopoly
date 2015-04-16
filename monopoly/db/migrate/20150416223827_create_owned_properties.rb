class CreateOwnedProperties < ActiveRecord::Migration
  def change
    create_table :owned_properties do |t|
      t.references :player, index: true, foreign_key: true
      t.references :board_space, index: true, foreign_key: true
      t.integer :num_houses

      t.timestamps null: false
    end
  end
end
