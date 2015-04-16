class Api::V1::PlayersController < Api::V1::ApplicationController
  def show
    player = Player.find(params[:id])

    player = JSON.parse(player.to_json( :include => [:owned_properties]))

    render json:  player
  end

end
