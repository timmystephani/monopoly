class GamesController < ApplicationController
  def new

  end

  def show
    @game = Game.find(params[:id])
  end
end