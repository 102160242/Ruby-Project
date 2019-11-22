class Api::Admin::AnswersController < Api::ApplicationController
    before_action :current_answer, except: [:create, :index] 
    respond_to :json
    def index
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:page].nil? ? 1 : params[:page]
        @per_page = params[:per_page].nil? ? 10 : params[:per_page]

        @answers = Answer.joins(:question)
                        .select("id", "answer_content","right_answer","question_id")
                        .where("answer_content LIKE ?", "%#{@search_key}%")
                        .order("answers.id #{@order}")

        @returnData = paginate_list(@answers.length, @page, @per_page)
        @answers = @answers.paginate(page: @page, :per_page => @per_page)

        @jsonData = []
        @answers.each do |i|
            @jsonData << i.as_json
        end
        
        @returnData["list"] = @jsonData
        render_json(@returnData) 
    end

    def destroy
        if(@answer.nil?)
            render_json("", "error", "Couldn't find the answer you're trying to delete!")
        else
            @answer.destroy
            render_json("", "success", "Deleted answer #{@answer.answer_content} successfully!")
        end
    end
    private
    def current_answer
        @answer ||= Answer.find_by(id: params[:answer_id])
    end
end
