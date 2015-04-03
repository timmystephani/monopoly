class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      flash[:notice] = 'Successfully created an account'
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:error] = 'There was a problem creating your account'
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:user).permit(:email, :password)
    end
end
