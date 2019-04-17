class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers]
  def show
    ## Get all tests of current user & all the followed users
    ids = @user.following.select(:id).map {|x| x.id} << @user.id
    @tests = Test.where(user_id: ids)
                .where.not(score: nil)
                .order("id DESC").limit(10)
  end

  def following
    @following = @user.following
                      .order("name ASC")
                      .paginate(page: params[:page], :per_page => 10)
  end

  def followers
    @followers = @user.followers   
                      .order("name ASC")
                      .paginate(page: params[:page], :per_page => 10)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
