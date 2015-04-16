class Api::V1::GamesController < Api::V1::ApplicationController
  def show
    game = Game.find(params[:id])
    history = game.histories.order('created_at DESC').limit(10)

    history = JSON.parse(history.to_json)

    # format created at
    history.each do |h|
      h['created_at_formatted'] = h['created_at'].to_datetime.strftime("%m/%d/%Y")
    end

    game = JSON.parse(game.to_json( :include => [:players]))
    
    game['history'] = history

    render json:  game 
  end

  def roll_dice
    game = Game.find(params[:id])

    game.roll_dice

    render json: { status: 200, message: 'success' }
  end
end