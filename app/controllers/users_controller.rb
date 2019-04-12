class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    ## Get all tests of current user & all the followed users
    ids = @user.following.select(:id).map {|x| x.id} << @user.id
    @tests = Test.where(user_id: ids)
                .where.not(score: nil)
                .order("id DESC").limit(10)
    # @tests = @user.tests
    # @user.following.each do |u|
    #   @tests.merge(u.tests)
    # end
    # @tests.order("id DESC").limit(10)
  end
end
