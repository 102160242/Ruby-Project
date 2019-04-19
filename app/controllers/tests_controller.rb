class TestsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update]
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests/1/edit
  def edit
    if !current_user.tests.include?(@test)
      show_404_error
    else
      if @test.created_at != @test.updated_at
        redirect_to @test
      end
    end
  end

  def show
    show_404_error if @test.created_at == @test.updated_at # Khong cho xem ket qua khi bai test chua duoc submit
    @chosen_answers = QuestionsTest.select(:question_id, :chosen_answer_id).where(:test_id => @test.id).all
  end

  # POST /tests
  # POST /tests.json
  def create
    category_id = params[:test][:category_id]
    @test = Test.new(user_id: current_user.id, category_id: category_id)
    
    respond_to do |format|
      if @test.save
        ## Lay ngau nhien cac cau hoi ##
        @questions = Question.joins(:category)
                            .where("categories.id = #{category_id}") # Lay cau hoi thuoc ve category user chon
                            .order("RANDOM()") # Lay ngau nhien
                            .first(20)  # 20 cau hoi
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
    if @test.created_at != @test.updated_at 
      respond_to do |format|
        format.html { redirect_to @test, notice: "Cheating activity is not allowed! You have done this test!" } # Khong cho phep user lam lai bai test da nop
      end
    else
      begin
        answers = params[:test][:answer_ids]
        score = 0
        @test.questions.each do |question|
          ans = answers["question_#{question.id}"]
          if !ans.nil?
            if question.answers.where("answers.id = #{ans.to_i}").first.right_answer
              score = score + 1
            end
            ## Cap nhat Answer ID da chon ##
            QuestionsTest.where(:question_id => question.id, :test_id => @test.id)
                        .update_all(:chosen_answer_id => ans.to_i)
          end
        end
        ## Luu diem ##
        @test.score = score
        @test.save

        respond_to do |format|
          format.html { redirect_to @test }
          format.json { render :show, status: :ok, location: @test }
        end
      rescue
        @test.score = 0
        @test.save
        respond_to do |format|
          format.html { redirect_to @test }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
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
