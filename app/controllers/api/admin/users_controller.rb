class Api::Admin::UsersController < Api::ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::DateHelper
  before_action :set_user, only: [:show, :update, :destroy, :userInfo]

  def index
    @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
    @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
    @page = params[:page].nil? ? 1 : params[:page]
    @per_page = params[:per_page].nil? ? 10 : params[:per_page]

    @users = User.select("id", "name", "email", "admin", "created_at").where("name LIKE ? OR email LIKE ?", "%#{@search_key}%", "%#{@search_key}%").order("created_at #{@order}")

    @returnData = paginate_list(@users.length, @page, @per_page)
    @users = @users.paginate(page: @page, :per_page => @per_page)

    @jsonData = []
    @users.each_with_index do |i, index|
    #p i.image.variant(resize: "500x500")
      @jsonData << i.as_json
      @jsonData[index]["total_learnt_words"] = i.words.count
      # {:id => i.id, :name => i.name, :email => i.email, :admin => i.admin, :created_at => :total_learnt_words => i.words.count}
    end
    
    @returnData["list"] = @jsonData
    render_json(@returnData) 
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

  def create
    @user = User.new(user_params)
    begin
        if @user.save
            render_json("", "success", "Created new user successfully!")
        else
            render_json("", "error", @user.errors.messages)
        end
    rescue Exception
        #p @category.errors
        render_json("", "error", @user.errors.messages)
        raise
    end
  end

  def userInfo
    @jsonData = {:id => @user.id, :name => @user.name, :email => @user.email, :avatar_url => gravatar_url(@user.email, 100),}
    render_json(@jsonData, "success", "")
  end

  def destroy
    begin
      if @user.destroy
          render_json("", "success", "Deleted user #{@user.email} successfully!")
      else
          render_json("", "error", @user.errors.messages)
      end
    rescue Exception
        #p @user.errors
        render_json("", "error", @user.errors.messages)
        raise
    end
  end

  def update
    begin
      if @user.update(user_params)
          render_json("", "success", "Updated User Successfully!")
      else
          render_json("", "error", @user.errors.messages)
      end
    rescue Exception
        #p @category.errors
        render_json("", "error", @user.errors.messages)
        raise
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
    @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
