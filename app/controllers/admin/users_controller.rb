class Admin::UsersController < ApplicationController
    layout "admin/layouts/application"
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    
    # GET /users
    # GET /users.json
    def index
        @users = User.all
                     .paginate(page: params[:page], :per_page => 6)
    end
    
    # GET /users/1
    # GET /users/1.json
    def show
        ## Get all tests of current user & all the followed users
        ids = @user.following.select(:id).map {|x| x.id} << @user.id
        @tests = Test.where(user_id: ids)
                    .where.not(score: nil)
                    .order("id DESC").limit(10)
    end
    
    # GET /users/new
    def new
        @user = User.new
    end
    
    # GET /users/1/edit
    def edit
    end
    
    # POST /users
    # POST /users.json
    def create
        @user = User.new(user_params)
        if @user.save
        flash[:success] = "Welcome to our website!"
        log_in @user
        redirect_to root_url
        else
        render 'new'
        end
    
        respond_to do |format|
        if @user.save
            format.html { redirect_to @user, notice: 'User was successfully created.' }
            format.json { render :show, status: :created, location: @user }
        else
            format.html { render :new }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        end
    end
    
    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
        respond_to do |format|
        if @user.update(user_params)
            format.html { redirect_to @user, notice: 'User was successfully updated.' }
            format.json { render :show, status: :ok, location: @user }
        else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        end
    end
    
    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        @user.destroy
        respond_to do |format|
        format.html { redirect_to admin_users_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
        end
    end
    
    private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
        @user = User.find(params[:id])
        end
    
        # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end

end
