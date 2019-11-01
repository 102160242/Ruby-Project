class Api::UsersController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token
    #respond_to :json

    def info
        @current_user = current_user
        render_json(@current_user)
        #render :json => { status: :success, data: @current_user }
    end
    
    private
    # def user_params
    #   params.require(:user).permit :email, :name, :password, :password_confirmation
    # end
    # def current_user
    #   @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
    # end
end
