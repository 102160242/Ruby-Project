class Api::UsersController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token
    before_action :user_params, only: [:update]
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
        render_json({ timeline: @tests, learnt_words_count: @user.words.count, following_count: @user.following.count, followers_count: @user.followers.count })        
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

    def follow
        begin
            @other_user = User.find(params[:id])
            current_user.follow(@other_user)
            render_json("", "success", "Followed user " + @other_user.name + "!")
        rescue Exception => e
            render_json("", "error", "There was an error while attemping to follow this user!" + e)
        end
    end

    def unfollow
        # @params = params[:id]
        # @attributes = Relationship.find(@params).followed
        begin
            @other_user = User.find(params[:id])
            current_user.unfollow(@other_user)
            render_json("", "success", "Unfollowed user " + @other_user.name + "!")
        rescue Exception => e
            render_json("", "error", "There was an error while attemping to unfollow this user!")
        end

    end

    def update
        @params = params[:user]#.reject{|_, v| v.blank?}
        @json = {}
        if @params[:current_password].empty?
            render_json("", "error", {password: ["can't be blank!"]})
        else
            #p "Mat khau hien tai la" + @attributes[:current_password]
            if @current_user.valid_password?(@params[:current_password])
                @attributes = {}
                @attributes[:name] = @params[:name] if !@params[:name].empty?
                if(!@params[:password].empty?)
                    if(@params[:password] == @params[:password_confirmation])
                        @attributes[:password] = @params[:password]
                    else
                        render_json("", "error", {password: ["confirmation is not matched!"]})
                        return
                    end
                end
                p "Attributes la "
                p @attributes
                @result = current_user.update(@attributes)
                if(@result)
                    render_json("", "success", "Updated Successfully!")
                else
                    render_json("", "error", current_user.errors)                    
                end
            else
                render_json("", "error", {password: ["is invalid!"]})             
            end
        end
    end
    
    private

    def user_params
      params.require(:user).permit :email, :name, :password, :password_confirmation
    end
    # def current_user
    #   @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
    # end
end
