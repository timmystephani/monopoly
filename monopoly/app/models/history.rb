class History < ActiveRecord::Base
  belongs_to :game
  validates :details, presence: true
end
