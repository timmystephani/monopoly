class CreateBoardSpaces < ActiveRecord::Migration
  def change
    create_table :board_spaces do |t|
      t.string :name
      t.integer :position
      t.string :type

      t.timestamps null: false
    end
  end
end
