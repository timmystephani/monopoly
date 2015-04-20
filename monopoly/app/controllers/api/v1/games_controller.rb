class Api::V1::GamesController < Api::V1::ApplicationController
  def show
    game = Game.find(params[:id])
    history = game.histories.order('created_at DESC').limit(10)

    history = JSON.parse(history.to_json)

    # format created at
    history.each do |h|
      h['created_at_formatted'] = h['created_at'].to_datetime.strftime("%m/%d %l:%M%P")
    end

    game = JSON.parse(game.to_json( :include => [:players => {:include => [:owned_properties]}]))

    game['history'] = history

    render json:  game
  end

  def roll_dice
    game = Game.find(params[:id])

    game.roll_dice

    render json: { status: 200, message: 'success' }
  end

  def respond_to_property_purchase
    game = Game.find(params[:id])

    yes_no = params[:yes_no]

    game.respond_to_property_purchase(yes_no)

    render json: { status: 200, message: 'success' }
  end

  def create
    game = Game.new
    game.current_player_id = 1 # updating later
    game.save

    params[:players].each do |number, info|
      player = Player.new
      user = User.find_by_email(info['email'])
      player.user_id = user.id
      player.game_id = game.id
      player.name = user.email
      player.save
    end

    first_player = game.players.first
    game.created_user_id = first_player.user_id
    game.current_player_id = first_player.id
    game.save

    render json: { status: 200, message: 'success' }
  end
end
