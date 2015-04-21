class GamesController < ApplicationController
  def new

  end

  def show
    @game = Game.find(params[:id])

    game_players = @game.players.map { |p| p.id }
    user_players = current_user.players.map { |p| p.id }

    @player_id = (game_players & user_players).first # should only be 1 intersection
  end
end