class AddCreatedUserIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :created_user_id, :int
  end
end
