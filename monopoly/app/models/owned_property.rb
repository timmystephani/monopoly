class OwnedProperty < ActiveRecord::Base
  belongs_to :player
  belongs_to :board_space
  validates :num_houses, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
  validates :num_houses, presence: true
  after_initialize :init

  def init
    self.num_houses ||= 0
  end
end
