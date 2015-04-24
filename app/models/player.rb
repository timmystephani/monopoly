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
  validates :name, presence: true
  validates :cash, presence: true
  validates_inclusion_of :in_jail, :in => [true, false]
  validates :position, presence: true
  after_initialize :init

  def init
    self.cash ||= 1500
    self.in_jail ||= false
    self.position ||= 0
  end
end
