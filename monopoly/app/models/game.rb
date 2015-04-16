# == Schema Information
#
# Table name: games
#
#  id                :integer          not null, primary key
#  current_player_id :integer
#  status            :string
#  free_parking_pot  :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  created_user_id   :integer
#

class Game < ActiveRecord::Base
  has_many :players
  has_many :histories

  def self.statuses
    statuses = []
    statuses << 'WAITING_FOR_PLAYERS'
    statuses << 'IN_PROGRESS'
    statuses << 'FINISHED'
    statuses
  end

end
