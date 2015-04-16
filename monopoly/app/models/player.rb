# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  name       :string
#  token      :string
#  cash       :integer
#  in_jail    :boolean
#  jail_rolls :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :owned_properties
end
