class User < ActiveRecord::Base
  validates :email, presence:true
  validates :password, presence:true

  has_many :players
  has_many :games, :through => :players
end
