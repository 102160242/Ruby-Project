class Api::UsersController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token
    #respond_to :json

    def info
        @current_user = current_user
        render_json(@current_user)
        #render :json => { status: :success, data: @current_user }
    end

    def newsfeed
        @user = current_user
        ids = @user.following.select(:id).map {|x| x.id} << @user.id
        @tests = Test.where(user_id: ids)
                    .where.not(score: nil)
                    .order("id DESC").limit(10)
        render_json(@tests)        
    end

    def following
        @following = @current_user.following.select("id", "name", "email")
                            .order("name ASC")
        render_json(@following)
    end

    def followers
        @followers = @current_user.followers.select("id", "name", "email")
                            .order("name ASC")
        render_json(@followers)
    end
    
    private
    # def user_params
    #   params.require(:user).permit :email, :name, :password, :password_confirmation
    # end
    # def current_user
    #   @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
    # end
end
