class Api::V1::PlayersController < Api::V1::ApplicationController
  def show
    player = Player.find(params[:id])

    player = JSON.parse(player.to_json( :include => [:owned_properties]))

    render json:  player
  end

  def pay_out_of_jail
    player = Player.find(params[:id])
    
    player.in_jail = false
    player.cash -= 50
    player.save

    history = History.new
    history.game_id = player.game.id
    history.details = player.name + ' paid $50 to get out of jail.'
    history.save
    
    render json: { status: 200, message: 'success' }
  end

end
