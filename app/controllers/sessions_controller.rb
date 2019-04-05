class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:username].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:info] = 'Logged out successfully'
    redirect_to root_url
  end
end