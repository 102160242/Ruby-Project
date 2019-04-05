class SessionsController < ApplicationController

  def new
    redirect_to root_url if logged_in?
  end

  def create
    user = User.find_by(username: params[:username].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = 'Logged out successfully'
    redirect_to root_url
  end

end