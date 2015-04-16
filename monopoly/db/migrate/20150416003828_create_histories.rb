class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.text :details
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
