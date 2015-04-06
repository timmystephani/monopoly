class Api::V1::BoardSpacesController < Api::V1::ApplicationController
  def index
    @board_spaces = BoardSpace.order(:position).all

    render json: @board_spaces
  end
end