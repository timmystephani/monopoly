# == Schema Information
#
# Table name: games
#
#  id                            :integer          not null, primary key
#  current_player_id             :integer
#  status                        :string
#  free_parking_pot              :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_user_id               :integer
#  user_prompt_type              :string
#  user_prompt_question          :string
#  current_player_doubles_rolled :integer
#

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
