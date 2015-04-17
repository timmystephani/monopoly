class AddUserPromptsToGame < ActiveRecord::Migration
  def change
    add_column :games, :user_prompt_type, :string
    add_column :games, :user_prompt_question, :string
  end
end
