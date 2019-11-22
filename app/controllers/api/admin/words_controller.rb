class Api::Admin::WordsController < Api::ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :wordinfo]
  def index
    @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
    @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
    @page = params[:page].nil? ? 1 : params[:page]
    @per_page = params[:per_page].nil? ? 10 : params[:per_page]

    @words = Word.select("id", "word", "meaning", "word_class", "ipa").where("word LIKE ?", "%#{@search_key}%").order("word #{@order}")

    @returnData = paginate_list(@words.length, @page, @per_page)
    @words = @words.paginate(page: @page, :per_page => @per_page)

    @jsonData = []
    @words.each_with_index do |i, index|
    #p i.image.variant(resize: "500x500")
      @jsonData << {
        id: i.id,
        word: i.word,
        meaning: i.meaning,
        word_class: Word.word_class_name(i.word_class),
        ipa: i.ipa,
        image_url: i.image.attached? ? url_for(i.image.variant(resize: "500x500")): ""
      }
      #@jsonData[index]["total_learnt_words"] = i.words.count
      # {:id => i.id, :name => i.name, :email => i.email, :admin => i.admin, :created_at => :total_learnt_words => i.words.count}
    end
    
    @returnData["list"] = @jsonData
    render_json(@returnData) 
  end

  def wordinfo
    @category_id = @word.category_ids[0]
    @jsonData = {
      id: @word.id,
      word: @word.word,
      meaning: @word.meaning,
      word_class: @word.word_class,
      ipa: @word.ipa,
      image_url: @word.image.attached? ? url_for(@word.image.variant(resize: "500x500")): "",
      category_id: @category_id,
      category_name: Category.find(@category_id).name
      # category_name: @category_name.name
    }
    render_json(@jsonData, "success", "")
  end

  def create
    p word_params
    @word = Word.new(word_params)
    begin
        if @word.save
            render_json("", "success", "Created new word successfully!")
        else
            render_json("", "error", @word.errors.messages)
        end
    rescue Exception
        #p @category.errors
        render_json("", "error", @word.errors.messages)
        raise
    end
  end

  def edit
  end

  def update
    begin
      if @word.update(word_params)
          render_json("", "success", "Updated Word Successfully!")
      else
          render_json("", "error", @word.errors.messages)
      end
    rescue Exception
        #p @category.errors
        render_json("", "error", @word.errors.messages)
        raise
    end
  end

  def destroy
    begin
      if @word.destroy
          render_json("", "success", "Deleted word #{@word.word} successfully!")
      else
          render_json("", "error", @word.errors.messages)
      end
    rescue Exception
        #p @word.errors
        render_json("", "error", @word.errors.messages)
        raise
    end
  end
  def options
    @categories = Category.all.collect {|p| { id: p.id, name: p.name} }
    @wordClass = []
    (1..4).each do |i|
      @wordClass << { id: i, name: Word.word_class_name(i) } 
    end
    render_json({ categories: @categories, class: @wordClass }, "success", "Request has been proccessed successfully!")
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:word_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
      params.require(:word).permit(:word, :meaning, :word_class, :ipa, :image, :category_ids => [])
  end
end
