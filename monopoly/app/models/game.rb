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


class Game < ActiveRecord::Base
  has_many :players
  has_many :histories
  has_many :used_comm_chest_chances
  has_many :owned_properties

  def self.statuses
    statuses = []
    statuses << 'WAITING_FOR_PLAYERS'
    statuses << 'IN_PROGRESS'
    statuses << 'WAITING_ON_USER_INPUT'
    statuses << 'FINISHED'
    statuses
  end

  def roll_dice
    turn_history = []

    die1 = 1 + rand(6)
    die2 = 1 + rand(6)

    #for debugging
    # die1 = 5
    # die2 = 4

    current_player = Player.find current_player_id
    current_board_space = BoardSpace.find_by_position current_player.position
    new_board_space_position = current_player.position + die1 + die2

    if new_board_space_position >= BoardSpace.all.length 
      turn_history << current_player.name + ' passed GO and collected $200.'
      current_player.cash += 200
      new_board_space_position -= BoardSpace.all.length
    end

    new_board_space = BoardSpace.find_by_position new_board_space_position

    current_player.position = new_board_space.position

    turn_history << current_player.name + ' rolled a ' + die1.to_s + ' and a ' + die2.to_s + ' and moved from ' + current_board_space.name + ' to ' + new_board_space.name + '.'

    if new_board_space.is_a? Property
      if new_board_space.owned_property.nil?
        # available to buy
        self.status = 'WAITING_ON_USER_INPUT'
        self.user_prompt_question = new_board_space.name + ' is available to purchase for $' + new_board_space.purchase_price.to_s + '. Would you like to purchase?'
        self.user_prompt_type = 'PROPERTY_PURCHASE'
      
      elsif new_board_space.owned_property.player.id == current_player.id
        # current user owns property
        turn_history << current_player.name + ' already owns ' + new_board_space.name + '.'
      else  
        # someone else owns it
        current_owner = new_board_space.owned_property.player

        turn_history << current_player.name + ' paid $' + new_board_space.rent_price.to_s + ' to ' + current_owner.name + ' for rent.'
        current_player.cash -= new_board_space.rent_price
        current_owner.cash += new_board_space.rent_price
        current_owner.save
      end

    elsif new_board_space.name == 'Luxury Tax'
      # TODO: what if user doesn't have enough money
      current_player.cash -= 75 # TODO: is this lux tax amount correct
      turn_history << current_player.name + ' paid Luxury Tax of $75.'
    end

    if status == 'IN_PROGRESS'
      self.current_player_id = get_next_player_id
    end

    if die1 == die2
      # self.current_player_doubles_rolled += 1
    end 

    # Save history
    save_history turn_history

    # Save current player
    current_player.save

    # Save game
    save

  end

  def respond_to_property_purchase(yes_no) 
    turn_history = []
    
    current_player = Player.find current_player_id
    new_property = BoardSpace.find_by_position current_player.position

    if yes_no == 'yes'
      op = OwnedProperty.new
      op.player_id = current_player.id
      op.board_space_id = new_property.id
      op.num_houses = 0
      op.save

      # TODO: what if they don't have enough cash
      current_player.cash -= new_property.purchase_price
      current_player.save
    
      turn_history << current_player.name + ' bought ' + new_property.name + ' for $' + new_property.purchase_price.to_s + '.'
    else
      turn_history << current_player.name + ' did not buy ' + new_property.name + '.'
    end

    save_history turn_history

    self.status = 'IN_PROGRESS'
    self.user_prompt_question = ''
    self.user_prompt_type = ''

    self.current_player_id = get_next_player_id
    save
  end

  private

  # Expects history to be an array 
  def save_history(turn_history)
    history = History.new
    history.game = self
    history.details = turn_history.join(' ')
    history.save
  end

  def get_next_player_id
    player_ids = players.map {|p| p.id }

    current_player_index = player_ids.index(current_player_id)
    if current_player_index == player_ids.length - 1
      return player_ids[0]
    else
      return player_ids[current_player_index + 1]
    end
  end

end
