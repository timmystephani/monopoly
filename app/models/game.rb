# == Schema Information
#
# Table name: games
#
#  id                            :integer          not null, primary key
#  current_player_id             :integer
#  status                        :string
#  free_parking_pot              :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_user_id               :integer
#  user_prompt_type              :string
#  user_prompt_question          :string
#  current_player_doubles_rolled :integer
#

class Game < ActiveRecord::Base
  has_many :players
  has_many :histories
  has_many :used_comm_chest_chances
  has_many :owned_properties
  validates :current_player_id, presence: true
  validates :status, presence: true
  validates :free_parking_pot, presence: true
  after_initialize :init

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
    # die1 = 20
    # die2 = 3

    current_player = Player.find current_player_id

    should_advance_to_next_player = true

    if die1 == die2
      self.current_player_doubles_rolled += 1
      should_advance_to_next_player = false
      if current_player_doubles_rolled == 3
        should_advance_to_next_player = true
        send_player_to_jail current_player
        turn_history << current_player.name + ' rolled doubles 3 times and went to jail.'
        finish_turn(current_player, turn_history, should_advance_to_next_player)
        return
      end
    end

    if current_player.in_jail
      if die1 == die2
        turn_history << current_player.name + ' rolled doubles and got out of jail.'
        current_player.in_jail = false
        should_advance_to_next_player = true
      else
        # keep track of player turns in jail
        if current_player.jail_rolls == 2
          turn_history << current_player.name + ' paid $50 to get out of jail.'
          current_player.cash -= 50
          current_player.in_jail = false
        else
          turn_history << current_player.name + ' did not roll doubles and is staying in jail.'
          current_player.jail_rolls += 1
          finish_turn(current_player, turn_history, should_advance_to_next_player)
          return
        end
      end
    end

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
      owned_property = OwnedProperty.where(:board_space_id => new_board_space.id, :player_id => players.map {|p| p.id }).first
      if owned_property.nil?
        # available to buy
        self.status = 'WAITING_ON_USER_INPUT'
        self.user_prompt_question = new_board_space.name + ' is available to purchase for $' + new_board_space.purchase_price.to_s + '. Would you like to purchase?'
        self.user_prompt_type = 'PROPERTY_PURCHASE'
        should_advance_to_next_player = false
      elsif owned_property.player.id == current_player.id
        # current user owns property
        turn_history << current_player.name + ' already owns ' + new_board_space.name + '.'
      else
        # someone else owns it
        current_owner = owned_property.player

        rent_price = new_board_space.rent_price
        if new_board_space.name == 'Electric Company' || new_board_space.name == 'Water Works'
          multiplier = get_special_property_multiplier current_owner
          rent_price = multiplier * (die1 + die2)
        end

        turn_history << current_player.name + ' paid $' + rent_price.to_s + ' to ' + current_owner.name + ' for rent.'
        current_player.cash -= rent_price
        current_owner.cash += rent_price
        current_owner.save
      end

    elsif new_board_space.name == 'Luxury Tax'
      # TODO: what if user doesn't have enough money
      current_player.cash -= 75 # TODO: is this lux tax amount correct
      turn_history << current_player.name + ' paid Luxury Tax of $75.'

    elsif new_board_space.name == 'Income Tax'
      self.status = 'WAITING_ON_USER_INPUT'
      self.user_prompt_question = 'You landed on Income Tax. Would you like to pay $200 or 10%?'
      self.user_prompt_type = 'INCOME_TAX'
      should_advance_to_next_player = false

    elsif new_board_space.name == 'Go to Jail'
      send_player_to_jail(current_player)

    elsif new_board_space.name == 'Community Chest'
      #get all comm chest cards already drawn for this game
      comm_chest_used = self.used_comm_chest_chances.where(card_type: :comm_chest)
      #get all community chest cards
      all_comm_chest = UsedCommChestChance.comm_chest_cards
      #remove all community chest cards already drawn
      comm_chest_used.each do |card|
        all_comm_chest.delete!(card)
      end

      card_drawn = nil
      #make sure still have cards left to be drawn
      if all_comm_chest.length != 0
        card_drawn = all_comm_chest.sample
      #no cards left to be drawn, undo all cards drawn then draw from all cards
      else
        UsedCommChestChance.where(card_type: :comm_chest and game_id: self.id).destroy_all
        all_comm_chest = UsedCommChestChance.comm_chest_cards
        card_drawn = all_comm_chest.sample
      end

      #add drawn card to game database
      u = UsedCommChestChance.new(:card_index => UsedCommChestChance.comm_chest_cards.index(card_drawn), :game_id => self.id, :card_type => :comm_chest)
      u.save

      #handle logic for card
      if u.card_index == 0 # advance to go
        current_player.position = 0
        current_player.cash += 200
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 1 # collect 75
        current_player.cash += 75
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 2 # doctor costs 50
        current_player.cash -= 50
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 3 # get out of jail free card
        #TODO how to handle this
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 4 # go to jail
        should_advance_to_next_player = false
        send_player_to_jail(current_player)
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 5 # collect 10 from each player
        #get all players
        self.players.each do |player|
          player.cash -= 10
          player.save
        end
        #current player loses money
        current_player.cash += 10 * (self.players.length - 1)
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 6 # opera - collect 50 from each player
        #get all players
        self.players.each do |player|
          player.cash -= 50
          player.save
        end
        #current player loses money
        current_player.cash += 50 * (self.players.length - 1)
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 7 # collect 20
        current_player.cash += 20
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 8 # collect 100
        current_player.cash += 100
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 9 # lose 100
        current_player.cash -= 100
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 10 # lose 50
        current_player.cash -= 50
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 11 # get 25
        current_player.cash += 25
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 12 # street repairs
        current_player.cash += 0
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 13 # get 10
        current_player.cash += 10
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 14 # get 100
        current_player.cash += 100
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 15 # get 50
        current_player.cash += 50
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 16 # get 100
        current_player.cash += 100
        turn_history << current_player.name + ' picked ' + card_drawn
      end

    elsif new_board_space.name == 'Chance'
      #get all chance cards already drawn for this game
      chance_used = self.used_comm_chest_chances.where(card_type: :chance)
      #get all chace cards
      all_chance = UsedCommChestChance.chance_cards
      #remove all chance cards already drawn
      chance_used.each do |card|
        all_chance.delete!(card)
      end

      card_drawn = nil
      #make sure still have cards left to be drawn
      if all_chance.length != 0
        card_drawn = all_chance.sample
      #no cards left to be drawn, undo all cards drawn then draw from all cards
      else
        UsedCommChestChance.where(card_type: :chance and game_id: self.id).destroy_all
        all_chance = UsedCommChestChance.chance_cards
        card_drawn = all_chance.sample
      end

      #add drawn card to game database
      u = UsedCommChestChance.new(:card_index => UsedCommChestChance.chance_cards.index(card_drawn), :game_id => self.id, :card_type => :chance)
      u.save

      #handle logic for card
      if u.card_index == 0 # advance to go
        current_player.position = 0
        current_player.cash += 200
        turn_history << current_player.name + ' picked ' + card_drawn
      elsif u.card_index == 1 # advance to illinois avenue
        #get cash for passing go
        if current_player.position > 24
          current_player.cash += 200
        end
        current_player.position = 24

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO handle property shit

      elsif u.card_index == 2 # advance to nearest utility
        if current_player.position <= 12 #electric
          current_player.position = 12
        elsif current_player.position <= 28 #water
          current_player.position = 28
        else #electric + cash
          current_player.position = 12
          current_player.cash += 200
        end

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO property owned logic - if owned, 10 times die roll

      elsif u.card_index == 3 # nearest railroad
        if current_player.position <= 5 #reading
          current_player.position = 5
        elsif current_player.position <= 15 #pennsylvania
          current_player.position = 15
        elsif current_player.position <= 25 #b&o
          current_player.position = 25
        elsif current_player.position <= 35 #shortline
          current_player.position = 35
        else #reading + cash
          current_player.position = 5
          current_player.cash += 200

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO railroad owned or not, pay twice if owned

      elsif u.card_index == 4 # advance to st. charles place
        #get cash for passing go
        if current_player.position > 11
          current_player.cash += 200
        end
        current_player.position = 11

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO handle property shit

      elsif u.card_index == 5 # bank pays $50
        current_player.cash += 50
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 6 # get out of jail free card
        #TODO how to handle this
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 7 # go back three spaces
        current_player.position -= 3
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 8 # go to jail
        should_advance_to_next_player = false
        send_player_to_jail(current_player)
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 9 # general repairs
        current_player.position += 0
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 10 # poor tax
        current_player.cash -= 10
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 11 # head to reading railroad
        #get cash for passing go
        if current_player.position > 5
          current_player.cash += 200
        end
        current_player.position = 5

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO handle property shit

      elsif u.card_index == 12 # boardwalk
        #get cash for passing go
        if current_player.position > 39
          current_player.cash += 200
        end
        current_player.position = 39

        turn_history << current_player.name + ' picked ' + card_drawn
        #TODO handle property shit

      elsif u.card_index == 13 # pay each player $50
        #get all players
        self.players.each do |player|
          player.cash += 50
          player.save
        end

        #current player loses money
        current_player.cash -= 50 * (self.players.length - 1)
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 14 # collect 150
        current_player.cash += 150
        turn_history << current_player.name + ' picked ' + card_drawn

      elsif u.card_index == 15 # collect 100
        current_player.cash += 100
        turn_history << current_player.name + ' picked ' + card_drawn

      end

    end

    self.die1 = die1
    self.die2 = die2

    finish_turn(current_player, turn_history, should_advance_to_next_player)
  end

  def finish_turn(current_player, turn_history, should_advance_to_next_player)
    if should_advance_to_next_player
      self.current_player_id = get_next_player_id
      self.current_player_doubles_rolled = 0
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

      turn_history << current_player.name + ' bought ' + new_property.name + ' for $' + new_property.purchase_price.to_s + '.'
    else
      turn_history << current_player.name + ' did not buy ' + new_property.name + '.'
    end

    self.status = 'IN_PROGRESS'
    self.user_prompt_question = ''
    self.user_prompt_type = ''

    finish_turn(current_player, turn_history, self.die1 != self.die2)
  end

  def respond_to_income_tax(two_hundred_or_ten_percent)
    turn_history = []

    current_player = Player.find current_player_id

    if two_hundred_or_ten_percent == '200'
      current_player.cash -= 200
      turn_history << current_player.name + ' paid $200 for Income Tax.'
    else # 10 percent
      ten_percent = 0.1 * current_player.cash
      ten_percent = ten_percent.to_i
      current_player.cash -= ten_percent
      turn_history << current_player.name + ' paid $' + ten_percent.to_s + ' for Income Tax.'
    end

    self.status = 'IN_PROGRESS'
    self.user_prompt_question = ''
    self.user_prompt_type = ''

    finish_turn(current_player, turn_history, self.die1 != self.die2)
  end

  private

  def get_special_property_multiplier(current_owner)
    board_space_ids = BoardSpace.where(:name => ['Water Works','Electric Company']).map{|bs| bs.id }

    owned_property_count = OwnedProperty.where(:player_id => current_owner.id, :board_space_id => board_space_ids).length

    if owned_property_count == 1
      return 4
    elsif owned_property_count == 2
      return 10
    end
  end

  def send_player_to_jail(current_player)
    current_player.position = 10 # visiting jail space
    current_player.in_jail = true
    current_player.jail_rolls = 0
  end

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

  def init
    self.status ||= 'IN_PROGRESS'
    self.free_parking_pot ||= 0
  end

end
