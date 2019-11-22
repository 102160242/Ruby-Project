class Api::UsersController < Api::ApplicationController
    include ApplicationHelper
    include ActionView::Helpers::DateHelper
    before_action :ensure_token_exist, :authenticate_user_from_token, except: [:newsfeed]
    before_action :user_params, only: [:update]
    #respond_to :json

    def info
        @current_user = current_user
        @json = @current_user.as_json
        @json[:avatar_url] = gravatar_url(@current_user.email, 100)
        @json[:total_followers] = @current_user.followers.count
        @json[:total_following] = @current_user.following.count
        @json[:total_learnt_words] = @current_user.words.count
        @json[:total_test] = @current_user.tests.count
        render_json(@json)
        #render :json => { status: :success, data: @current_user }
    end

    def newsfeed
        @user = User.find(params[:user_id])
        @user_info = { 
                        id: @user.id,
                        email: @user.email, 
                        name: @user.name, 
                        avatar_url: gravatar_url(@user.email, 100),
                        created_at: @user.created_at,
                        total_followers: @user.followers.count, 
                        total_following: @user.following.count,
                        total_learnt_words: @user.words.count,
                     }

        ids = @user.following.select(:id).map {|x| x.id} << @user.id
        @tests = Test.where(user_id: ids)
                    .where.not(score: nil)
                    .order("id DESC").limit(10)
        @timeline = []
        @tests.each do |i|
            @t = { id: i.id, user_id: i.user.id, user: i.user.email, category: i.category.name, category_img: url_for(i.category.image.variant(resize: "100x100")), score: i.score, time: time_ago_in_words(i.created_at) }
            @timeline << @t
        end
        render_json({ timeline: @timeline, user_info: @user_info })        
    end

    def following
        @user = User.find(params[:user_id])

        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @page = params[:search].nil? ? 1 : params[:page]
        @per_page = 10

        @following = @user.following
                        .where("name LIKE ?", "%#{@search_key}%")
                        .select("id", "name", "email")
                        .order("name ASC")

        @returnData = paginate_list(@following.length, @page, @per_page)
        @following = @following.paginate(page: @page, :per_page => @per_page)

        @following_json = @following.as_json
            
        @following.each_with_index do |i, index|
            @following_json[index]["is_following"] = true
        end

        @returnData["list"] = @following_json
        render_json(@returnData)
    end

    def followers
        @user = User.find(params[:user_id])
    
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @page = params[:search].nil? ? 1 : params[:page]
        @per_page = 10

        @followers = @user.followers
                          .where("name LIKE ?", "%#{@search_key}%")
                          .select("id", "name", "email")
                          .order("name ASC")
       
        @returnData = paginate_list(@followers.length, @page, @per_page)

        @followers = @followers.paginate(page: @page, :per_page => @per_page)
                          
        @follower_ids = @followers.map { |x| x.id }
        @following_ids = current_user.following.where(id: @follower_ids).select("id").map { |x| x.id }

        @followers_json = []
        @followers.each_with_index do |item, i|
            p i
            if(@following_ids.include?(item.id))
                @followers_json << { id: item.id, name: item.name, email: item.email, is_following: true }
                #i[:is_following] = true
            else
                @followers_json << { id: item.id, name: item.name, email: item.email, is_following: false }
                #i[:is_following] = false
            end
        end

        @returnData["list"] = @followers_json
        render_json(@returnData)
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
            render_json("", "error", "There was an error while attemping to unfollow this user!" + e)
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
                #p "Attributes la "
                #p @attributes
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
