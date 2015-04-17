class Property < BoardSpace
  validates :purchase_price, presence: true
  validates :rent_price, presence: true
end
