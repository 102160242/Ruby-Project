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

    def delete
        if(@question.nil?)
            render_json("", "error", "Couldn't find the question you're trying to delete!")
        else
            @question.destroy
            render_json("", "success", "Deleted question #{@question.question_content} successfully!")
        end
    end
    private
    def current_question
        @question ||= Question.find_by(id: params[:question_id])
    end
end
