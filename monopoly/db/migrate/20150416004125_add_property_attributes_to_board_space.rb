class AddPropertyAttributesToBoardSpace < ActiveRecord::Migration
  def change
    add_column :board_spaces, :purchase_price, :integer
    add_column :board_spaces, :rent_price, :integer
  end
end
