class Admin::AnswersController < ApplicationController
    layout "admin/layouts/application"
    before_action :authenticate_user!, :admin_user
    def index
      @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
      @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
      @answers = Answer.search(@search_key)
                 
      # Sap xep
      if @order == "answer_az"
          @answers = @answers.order("answer_content ASC")
      elsif @order == "answer_za"
          @answers = @answers.order("answer_content DESC")
      elsif @order == "id_az"
          @answers = @answers.order("id ASC")
      else
          @answers = @answers.order("id DESC") # Mac dinh sap xep theo ID tang dan
      end

      @answers = @answers.paginate(page: params[:page], :per_page => 15)
    end
    
      # GET /answers/1
      # GET /answers/1.json
      def show
        @answer = Answer.find(params[:id])
      end
    
      # GET /answers/new
      def new
        @answer = Answer.new
        if params[:question_id].nil?
          @question = Question.all.collect {|p| [ p.question_content, p.id]}
        else
          @question = Question.where(id: params[:question_id]).collect {|p| [ p.question_content, p.id]}
        end
      end
      
      def edit
        @answer = Answer.find(params[:id])
      end
      # GET /answers/1/edit
    #   def edit
    #     @answer = Answer.where("answer.id = #{params[:id]}")
    #     respond_to do |format|
    #         format.html render { redirect_to root_url, notice: params[:id] }
    #     end
    #   end
    
      # POST /answers
      # POST /answers.json
      def create
        @answer = Answer.new(answer_params)
    
        respond_to do |format|
          if @answer.save
            format.html { redirect_to admin_answers_path, notice: 'Answer was successfully created.' }
            format.json { render :show, status: :created, location: admin_answers_path }
          else
            format.html { render :new }
            format.json { render json: @answer.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # PATCH/PUT /answers/1
      # PATCH/PUT /answers/1.json
      def update
        @answer = Answer.find(params[:id])
        respond_to do |format|
          if @answer.update(answer_params)
            format.html { redirect_to admin_answers_path, notice: 'Answer was successfully updated.' }
            format.json { render :show, status: :ok, location: admin_answers_path }
          else
            format.html { render :edit }
            format.json { render json: @answer.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # DELETE /answers/1
      # DELETE /answers/1.json
      def destroy
        @answer = Answer.find(params[:id])
        @answer.destroy
        respond_to do |format|
          format.html { redirect_to admin_answers_path, notice: 'Answer was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_answer
          @answer = Answer.find(params[:id])
        end
    
        # Never trust parameters from the scary internet, only allow the white list through.
        def answer_params
          params.require(:answer).permit(:question_id, :answer_content, :right_answer)
        end
    end
    
