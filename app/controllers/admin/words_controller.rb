class Admin::WordsController < ApplicationController
  layout "admin/layouts/application"
  before_action :authenticate_user!, :admin_user
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
    @words = Word.search(@search_key)

    if @order == "word_az"
      @words = @words.order("words.word ASC")
    elsif @order == "word_za"
      @words = @words.order("words.word DESC")
    elsif @order == "id_az"
      @words = @words.order("words.id ASC")
    else
      @words = @words.order("words.id DESC")
    end
    @words = @words.paginate(page: params[:page], :per_page => 15)
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @words = Word.all.paginate(page: params[:page], :per_page => 15)
  end

  # GET /words/new
  def new
    @word = Word.new
    @categories = Category.all.collect {|p| [ p.name, p.id]}
  end

  # GET /words/1/edit
  def edit
    @categories = Category.all.collect {|p| [ p.name, p.id]}
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)
    respond_to do |format|
      if @word.save
        category_ids = params[:word][:category_ids].reject { |c| c.empty? }
        format.html { redirect_to admin_words_path, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: admin_words_path }
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
        format.html { redirect_to admin_words_path, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_words_path }
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
      format.html { redirect_to admin_words_path, notice: 'Word was successfully destroyed.' }
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
        params.require(:word).permit(:word, :meaning, :word_class, :ipa, :image, :category_ids => [])
    end
end
