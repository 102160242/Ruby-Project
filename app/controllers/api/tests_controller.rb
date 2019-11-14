class Api::TestsController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token
    before_action :set_test, only: [:index, :update, :result, :destroy]

    def index
        if !current_user.tests.include?(@test)
            render_json("", "error", "Test does not exist", 404)
        else
            if @test.score.nil?
                @test_json = @test.as_json
                @questions = @test.questions.select("id", "question_content")
                @questions_array = @questions.map { |i| { id: i.id, question_content: i.question_content, answers: {}}}
                @questions.each_with_index do |i, index|
                    @questions_array[index][:answers] = i.answers.select("id", "answer_content").as_json
                end
                @test_json[:questions] = @questions_array
                @test_json[:timeLeft] = 10*60 - (Time.zone.now - @test.created_at)
                render_json(@test_json)
            else
                render_json("", "error", "You are no longer be able to do this test!")
            end
        end
    end

    def result
        if(@test.nil? || !current_user.tests.include?(@test))
            render_json("", "error", "Test does not exist", 404)
        else
            if !@test.score.nil?

                @test_json = @test.as_json
                @test_json[:category] = @test.category.name
                @test_json[:category_img] = url_for(@test.category.image.variant(resize: "100x100"))
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
            else
                render_json("", "error", "You haven't done this test yet!")
            end
        end
    end

    def create
      #p current_user
      category_id = params[:test][:category_id]
      @test = Test.new(user_id: current_user.id, category_id: category_id)
      
      if @test.save
          ## Lay ngau nhien cac cau hoi ##
          @questions = Question.joins(:category)
                              .where("categories.id = #{category_id}") # Lay cau hoi thuoc ve category user chon
                              .order("RANDOM()") # Lay ngau nhien
                              .first(20)  # 20 cau hoi
          @test.questions << @questions
          
          render_json(@test) 
      else
        render_json("", "error", "Failed to create new test!")
      end
    end

    def update
      if @test.created_at != @test.updated_at
        render_json("", "error", "Cheating activity is not allowed! You have done this test!")
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
          
          render_json("", "success", "Test has been submitted successfully!")
        rescue
          @test.score = 0
          @test.save
          render_json("", "error", @test.errors)
        end
      end
    end

    private
      def set_test
        @test = Test.find_by(:id => params[:id])
      end
      def test_params
        params.require(:test).permit(:category_id, answer_ids: [])
      end
end