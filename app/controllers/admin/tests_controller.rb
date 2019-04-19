class Admin::TestsController < ApplicationController
  layout "admin/layouts/application"
    before_action :authenticate_user!, :admin_user
    before_action :set_test, only: [:show, :edit, :update, :destroy]
  
    # GET /tests/1/edit
    def index
      @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
      @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
      @tests = Test.search(@search_key)
                   .order("id #{@order == "az" ? "ASC" : "DESC"}")
                   .paginate(page: params[:page], :per_page => 6)
    end
    
    def new
      @test = Test.new
      @users = User.all.collect {|p| [ p.name, p.id]}
      @categories = Category.all.collect {|p| [ p.name, p.id]}
    end
    
    def show
      @chosen_answers = QuestionsTest.select(:question_id, :chosen_answer_id).where(:test_id => @test.id).all
    end
  
    # POST /tests
    # POST /tests.json
    def create
      category_id = params[:test][:category_id]
      @test = Test.new(user_id: current_user.id, category_id: category_id)
      
      respond_to do |format|
        if @test.save
          ## Get Random Questions ##
          @questions = Question.joins(:category)
                              .where("categories.id = #{category_id}") # Question belongs to the Category user chose
                              .order("RANDOM()") # Take random records
                              .first(20)
          @test.questions << @questions
  
          format.html { redirect_to admin_tests_path }
          format.json { render :edit, status: :created, location: admin_tests_path }
          format.js {}
        end
  
        format.html { redirect_to root_url }
        format.json { render json: @test.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
    
    def edit
      @categories = Category.all.collect {|p| [ p.name, p.id]}
    end
  
    # PATCH/PUT /tests/1
    # PATCH/PUT /tests/1.json
    def update
      if @test.update(test_params)
        respond_to do |format|
          format.html { redirect_to admin_tests_path }
          format.json { render :show, status: :ok, location: admin_tests_path }
        end
      else
        respond_to do |format|
          format.html { render :edit, notice: "Please do you test again. An unexpected error has occured!" }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      end              
    end

    def destroy
      @test.destroy
      respond_to do |format|
        format.html { redirect_to admin_tests_path, notice: 'Test was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_test
        @test = Test.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def test_params
        params.require(:test).permit(:category_id, :score)
      end
end
