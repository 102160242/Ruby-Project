class Admin::QuestionsController < ApplicationController
  layout "admin/layouts/application"
  before_action :authenticate_user!, :admin_user
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  
  # GET /questions
  # GET /questions.json
  def index
      @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
      @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
      @questions = Question.search(@search_key)            

      # Sap xep
      if @order == "question_az"
          @questions = @questions.order("question_content ASC")
      elsif @order == "question_za"
          @questions = @questions.order("question_content DESC")
      elsif @order == "id_az"
          @questions = @questions.order("id ASC")
      else
          @questions = @questions.order("id DESC") # Mac dinh sap xep theo ID tang dan
      end

      @questions = @questions.paginate(page: params[:page], :per_page => 15)
  end
  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
  end

  # GET /questions/new
  def new
    @question = Question.new
    @categories = Category.all.collect {|p| [ p.name, p.id]}
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to admin_questions_path, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: admin_questions_path }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to admin_questions_path, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_questions_path }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    respond_to do |format|
      format.html { redirect_to admin_questions_path, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:question_content, :category_id)
    end
end
