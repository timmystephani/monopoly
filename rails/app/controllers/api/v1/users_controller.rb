class Api::V1::UsersController < Api::V1::ApplicationController
    before_filter :authenticate, :only => [:games]  

  def show
    user = User.find_by_email(params[:email])

    if user.nil?
      render json: {}
    else
      render json:  user
    end
  end

  def auth_token
    email = params[:user][:email] if params[:user]
    password = params[:user][:password] if params[:user]

    render_unauthorized if email.blank? || password.blank?

    user = User.find_by_email email

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return_json = JSON.parse(user.to_json)
      return_json['auth_token'] = user.auth_token
      render json: return_json
    else
      render_unauthorized
    end
  end

  def games  
    render json: @current_user.games,  :include => [ 
                                                    :players => { :include => [:user]},
                                                    ]
  end 

  

end
