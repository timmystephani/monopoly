class Api::V1::UsersController < Api::V1::ApplicationController
  def show
    user = User.find_by_email(params[:email])

    if user.nil?
      render json: {}
    else
      render json:  user
    end
  end

end
