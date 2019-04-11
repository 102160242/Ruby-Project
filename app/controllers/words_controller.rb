class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index]

  def add_learnt_word   
    respond_to do |format|    
      @word = Word.find_by(id: params[:word][:id])
      if !@word.nil?
        if current_user.words.include?(@word)
          if params[:word][:option] == "add"
            notice_message = 1
            format.js { render :action => "add_learnt_word_notice" }
            format.json { render :json => { status: "error", msg: "This word has already been in your list!" } }
          else
            current_user.words.delete(@word)
            format.js { }
            format.json { render :json => { status: :ok } }
          end
        else
          if params[:word][:option] == "add"
            current_user.words << @word
            format.js { }
            format.json { render :json => { status: :ok } }
          else
            notice_message = 2
            format.js { render :action => "add_learnt_word_notice" }
            render :json => { status: :error, msg: "Word is not in your list!" }
          end
        end
      else
        notice_message = 3
        format.js { render :action => "add_learnt_word_notice" }   
        render :json => { status: :error, msg: "Word does not exist!" }
      end
    end
  end

  # GET /words
  # GET /words.json
  def index
    @category = Category.find_by(id: params[:category_id])
    redirect_to root_url if @category.nil?
    @words = Word.joins(:categories)
                 .where("categories.id = #{params[:category_id]}")
                 .paginate(page: params[:page], :per_page => 10)
    @my_words = Word.joins(:categories)
                     .where("categories.id = #{params[:category_id]}")
                     .joins(:users)
                     .where("users.id = #{current_user.id}")
                     .last(10)
                     .reverse
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:word, :meaning, :word_class, :image)
    end
end
