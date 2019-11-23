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
            #p @question.errors
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

    def edit
        @returnData = paginate_list(1, 1, 1)
        @jsonData = []
        @jsonData << {:id => @question.id, :name => @question.name, :image_url => @image_url}
        @returnData["list"] = @jsonData
        render_json(@returnData)
    end

    def update
        begin
            if @question.update(question_params)
                render_json("", "success", "update question successfully!")
            else
                render_json("", "error", @question.errors.messages)
            end
        rescue Exception
            #p @question.errors
            render_json("", "error", @question.errors.messages)
            raise
        end
    end

    def options
        @questions = Question.all.collect {|p| { id: p.id, question_content: p.question_content} }
        render_json({ questions: @questions }, "success", "Request has been proccessed successfully!")
    end
    private
    def current_question
        @question ||= Question.find_by(id: params[:question_id])
    end
    def question_params
        params.require(:question).permit(:question_content, :category_id, :answers => [{}])
      end
end
