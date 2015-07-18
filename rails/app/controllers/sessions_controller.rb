class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      flash[:notice] = 'Successfully logged in'
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:error] = 'There was a problem logging in'
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out'
    redirect_to '/'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:user).permit(:email, :password)
    end
end
