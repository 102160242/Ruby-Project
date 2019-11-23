class Api::Admin::TestsController < Api::ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy, :result]
  respond_to :json

  def index
    @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
    @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
    @page = params[:page].nil? ? 1 : params[:page]
    @per_page = params[:per_page].nil? ? 10 : params[:per_page]

    @tests = Test.joins(:user)
                .joins(:category)
                .select("tests.id", "users.email as user_email", "categories.name as category_name", "score", "created_at")
                .where("category_name LIKE ? OR user_email LIKE ?", "%#{@search_key}%", "%#{@search_key}%")
                .order("tests.id #{@order}")

    @returnData = paginate_list(@tests.length, @page, @per_page)
    @tests = @tests.paginate(page: @page, :per_page => @per_page)
    
    @returnData["list"] = @tests
    render_json(@returnData) 
  end

  def edit
  end

  def update
  end

  def show
    @test_json = @test.as_json
    @test_json[:category] = @test.category.name
    @test_json.delete("updated_at")
    
    ## Lay danh sach cac cau hoi cung cau tra loi
    @questions = @test.questions.select("id", "question_content")
    @questions_array = @questions.map { |i| { id: i.id, question_content: i.question_content, answers: {}}}

    @_array = QuestionsTest.select(:question_id, :chosen_answer_id).where(:test_id => @test.id).all
    @chosen_answers_array = {}
    @_array.each do |i|
        @chosen_answers_array[i.question_id] = i.chosen_answer_id
    end
    @questions.each_with_index do |i, index|
        @questions_array[index][:answers] = i.answers.select("id", "answer_content", "right_answer").as_json
        @questions_array[index][:chosen_answer_id] = @chosen_answers_array[i.id]
    end

    @test_json[:questions] = @questions_array
    render_json(@test_json)
  end

  def create
    params_ = test_params
    @test = Test.new(test_params)
    begin
        if @test.save
          @questions = Question.joins(:category)
                    .where("categories.id = #{params_[:category_id]}") # Question belongs to the Category user chose
                    .order("RANDOM()") # Take random records
                    .first(20)
          p @questions
          @test.questions << @questions
          @test.save
            render_json("", "success", "Created new user successfully!")
        else
            render_json("", "error", @test.errors.messages)
        end
    rescue Exception
        #p @category.errors
        render_json("", "error", @test.errors.messages)
        raise
    end
  end

  def destroy
    begin
      if @test.destroy
          render_json("", "success", "Deleted successfully!")
      else
          render_json("", "error", @test.errors.messages)
      end
    rescue Exception
        #p @user.errors
        render_json("", "error", @test.errors.messages)
        raise
    end
  end
  def options
    @categories = Category.all.collect {|p| { id: p.id, name: p.name} }
    @users = User.all.collect {|p| { id: p.id, email: p.email} }
    render_json({ categories: @categories, users: @users }, "success", "Request has been proccessed successfully!")
  end
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:test_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:user_id, :category_id, :score)
    end
end
