class Api::Admin::QuestionsController < Api::ApplicationController
    before_action :current_question, except: [:create, :index] 
    respond_to :json
    def index
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:page].nil? ? 1 : params[:page]
        @per_page = params[:per_page].nil? ? 10 : params[:per_page]

        @questions = Question.joins(:category)
                             .select("id", "question_content", "name as category_name")
                             .where("question_content LIKE ?", "%#{@search_key}%")
                             .order("questions.id #{@order}")
        @returnData = paginate_list(@questions.length, @page, @per_page)
        @questions = @questions.paginate(page: @page, :per_page => @per_page)

        @jsonData = []
        @questions.each do |i|
        @jsonData << i.as_json
        end
        
        @returnData["list"] = @jsonData
        render_json(@returnData) 
    end

    def getinfo
        @question = Question.find(params[:question_id])
        @category_name = Category.find(@question.category_id).name
        @answers = @question.answers.select("id", "question_id", "answer_content", "right_answer").as_json
        @jsonData = {
            question_content: @question.question_content,
            category_id: @question.category_id,
            category_name: @category_name,
            answers: @answers
        }
        render_json(@jsonData, "success", "")
    end

    def create
        @question = Question.new({ question_content: params[:question][:question_content], category_id: params[:question][:category_id] })
        begin
            if @question.save
                answers = params[:question][:answers]
                #p "#########################"
                answers.each do |i|
                    @answer_params = { question_id: @question.id, answer_content: i[:answer_content], right_answer: i[:right_answer] }
                    @answer = Answer.new(@answer_params)
                    if !@answer.save
                        @question.destroy
                        render_json("", "error", @answer.errors.messages)
                        return
                    end
                end
                if @question.save
                    render_json("", "success", "Created new question successfully!")
                end
                return
            end
            render_json("", "error", @question.errors.messages)
        rescue Exception
            #p @category.errors
            render_json("", "error", @question.errors.messages)
            raise
        end
    end

    def update
        begin
            params_ = params[:question]
            @question.question_content = params_[:question_content]
            @question.category_id = params_[:category_id]
            if @question.save
                answers_params = params_[:answers]
                #p "#########################"
                answers_params.each do |i|
                    answer = @question.answers.find(i[:id])
                    answer.answer_content = i[:answer_content]
                    answer.right_answer = i[:right_answer]
                    if !answer.save
                        render_json("", "error", answer.errors.messages)
                        return
                    end
                end
                if @question.save
                    render_json("", "success", "Created new question successfully!")
                end
                return
            end
            render_json("", "error", @question.errors.messages)
        rescue Exception
            #p @category.errors
            render_json("", "error", @question.errors.messages)
            raise
        end
      end

    def destroy
        if(@question.nil?)
            render_json("", "error", "Couldn't find the question you're trying to delete!")
        else
            @question.destroy
            render_json("", "success", "Deleted question #{@question.question_content} successfully!")
        end
    end
    def options
        @categories = Category.all.collect {|p| { id: p.id, name: p.name} }
        render_json({ categories: @categories }, "success", "Request has been proccessed successfully!")
    end
    private
    
    def current_question
        @question ||= Question.find_by(id: params[:question_id])
    end
    def question_params
        params.require(:question).permit(:question_content, :category_id, :answers => [{}])
      end
end
