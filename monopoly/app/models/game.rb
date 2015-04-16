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

  def roll_dice
    turn_history = []

    #for debugging
    die1 = 5
    die2 = 4

    current_player = Player.find current_player_id
    current_board_space = BoardSpace.find_by_position current_player.position
    new_board_space_position = current_player.position + die1 + die2

    # TODO: check edge cases here
    if new_board_space_position >= BoardSpace.all.length 
      turn_history << current_player.name + ' passed GO and collected $200.'
      current_player.cash += 200
      new_board_space_position -= BoardSpace.all.length
    end

    new_board_space = BoardSpace.find_by_position new_board_space_position

    current_player.position = new_board_space.position
    
    turn_history << current_player.name + ' rolled a ' + die1.to_s + ' and a ' + die2.to_s + ' and moved from ' + current_board_space.name + ' to ' + new_board_space.name + '.'

    self.current_player_id = get_next_player_id
    
    # Save history
    history = History.new
    history.game = self
    history.details = turn_history.join(' ')
    history.save

    # Save current player
    current_player.save

    # Save game
    save

  end

  private

  def get_next_player_id
    player_ids = Game.first.players.map {|p| p.id }
    
    current_player_index = player_ids.index(current_player_id)
    if current_player_index == player_ids.length
      return player_ids[0]
    else
      return player_ids[current_player_index + 1]
    end
  end

end
