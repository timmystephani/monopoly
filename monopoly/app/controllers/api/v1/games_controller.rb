class Api::V1::GamesController < Api::V1::ApplicationController
  def show
    game = Game.find(params[:id])
    history = game.histories.order('created_at DESC').limit(10)
    
    game = JSON.parse(game.to_json( :include => [:players]))
    game['history'] = history

    render json:  game 
  end
end