class TestsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update]
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests/1/edit
  def edit
    if !current_user.tests.include?(@test)
      render file: Rails.public_path.join("404.html"), layout: false
    else
      if @test.created_at != @test.updated_at
        redirect_to learn_path(@test.category)
      end
    end
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

        format.html { redirect_to do_test_path(@test) }
        format.json { render :edit, status: :created, location: do_test_path(@test) }
        format.js {}
      end

      format.html { redirect_to root_url }
      format.json { render json: @test.errors, status: :unprocessable_entity }
      format.js {}
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    begin
      answers = params[:test][:answer_ids]
      score = 0
      @test.questions.each do |question|
        ans = answers["question_#{question.id}"]
        if !ans.nil?
          if question.answers.where("answers.id = #{ans.to_i}").first.right_answer
            score = score + 1
          end
          ## Update Chosen Answer ID ##
          QuestionsTest.where(:question_id => question.id, :test_id => @test.id)
                      .update_all(:chosen_answer_id => ans.to_i)
          ## Save Score ##
          @test.score = score
          @test.save
        end
      end
      respond_to do |format|
        format.html { redirect_to @test }
        format.json { render :show, status: :ok, location: @test }
      end
    rescue
      respond_to do |format|
        format.html { render :edit, notice: "Please do you test again. An unexpected error has occured!" }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:category_id, answer_ids: [])
    end
end
