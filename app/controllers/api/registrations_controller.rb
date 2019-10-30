class Api::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist

  respond_to :json

  def create
    user = User.new user_params
    if user.save
      render json: {status: "success", message: "Registration has been completed", data: user}, status: 200
    else
      warden.custom_failure!
      render json: {status: "error", message: user.errors.messages}, status: 200
    end
  end

  def ensure_params_exist
    return unless params[:user].blank?
     render json: {status: "error", message: "Missing params"}, status: 422
   end
 
   def load_user_authentication
     @user = User.find_by_email user_params[:email]
     return login_invalid unless @user
   end
 
   def login_invalid
     render json:
       {status: "error", message: "Invalid login"}, status: 200
   end
   
  private
  def user_params
    params.require(:user).permit :email, :name, :password, :password_confirmation
  end
  def current_user
    @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
  end

  def authenticate_user_from_token
    render json: {status: "error", message: "You are not authenticated"},
      status: 401 if current_user.nil?
  end
end