class UsedCommChestChance < ActiveRecord::Base
  belongs_to :game
  enum card_type: [:chance, :comm_chest]
  validates :card_index, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 16}
  validates :card_index, presence: true

  def self.chance_cards
    chance_cards = []
    chance_cards << 'Advance to Go (Collect $200)'
    chance_cards << 'Advance to Illinois Ave. - If You Pass Go, Collect $200'
    chance_cards << 'Advance token to nearest Utility. If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total ten times the amount thrown.'
    chance_cards << 'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank.'
    chance_cards << 'Advance to St. Charles Place - If You Pass Go, Collect $200'
    chance_cards << 'Bank pays you dividend of $50'
    chance_cards << 'Get out of Jail free - this card may be kept until needed, or traded/sold'
    chance_cards << 'Go back 3 spaces'
    chance_cards << 'Go directly to Jail - do not pass Go, do not collect $200'
    chance_cards << 'Make general repairs on all your property - for each house pay $25 - for each hotel $100'
    chance_cards << 'Pay poor tax of $15'
    chance_cards << 'Take a trip to Reading Railroad - if you pass Go collect $200'
    chance_cards << 'Take a walk on the Boardwalk - Advance Token to Boardwalk'
    chance_cards << 'You have been elected chairman of the board - pay each player $50'
    chance_cards << 'Your Building and Loan Matures - Collect $150'
    chance_cards << 'You have won a crossword competition - Collect $100'
    chance_cards
  end

  def self.comm_chest_cards
    comm_chest_cards = []
    comm_chest_cards << 'Advance to Go (Collect $200)'
    comm_chest_cards << 'Bank error in your favor - collect $75'
    comm_chest_cards << "Doctor's fees - Pay $50"
    comm_chest_cards << 'Get out of jail free - this card may be kept until needed, or sold'
    comm_chest_cards << 'Go to jail - go directly to jail - Do not pass Go, do not collect $200'
    comm_chest_cards << 'It is your birthday Collect $10 from each player'
    comm_chest_cards << 'Grand Opera Night - collect $50 from every player for opening night seats'
    comm_chest_cards << 'Income Tax refund - collect $20'
    comm_chest_cards << 'Life Insurance Matures - collect $100'
    comm_chest_cards << 'Pay Hospital Fees of $100'
    comm_chest_cards << 'Pay School Fees of $50'
    comm_chest_cards << 'Receive $25 Consultancy Fee'
    comm_chest_cards << 'You are assessed for street repairs - $40 per house, $115 per hotel'
    comm_chest_cards << 'You have won second prize in a beauty contest - collect $10'
    comm_chest_cards << 'You inherit $100'
    comm_chest_cards << 'From sale of stock you get $50'
    comm_chest_cards << 'Holiday Fund matures - Receive $100'
    comm_chest_cards
  end
end
