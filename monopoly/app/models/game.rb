class Game < ActiveRecord::Base
  has_many :players

  def self.statuses
    statuses = []
    statuses << 'WAITING_FOR_PLAYERS'
    statuses << 'IN_PROGRESS'
    statuses << 'FINISHED'
    statuses
  end

end
