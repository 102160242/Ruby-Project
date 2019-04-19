class WordsController < ApplicationController
  before_action :authenticate_user!

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
    # Lay du lieu filter & search cua user
    @category = Category.find_by(id: params[:category_id])
    redirect_to root_url if @category.nil?

    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @filter = (params[:filter].nil? || params[:filter] == "") ? "" : params[:filter]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]

    @words = Word.joins(:categories)
                 .where("categories.id = #{params[:category_id]}")
                 .search(@search_key)
                 
    if @filter == "learnt" || @filter == "unlearnt"
      @words = Word.learnt(current_user.id, @filter == "learnt")
    end

    @words = @words.order("words.word #{@order == "za" ? "DESC" : "ASC"}")
                   .paginate(page: params[:page], :per_page => 10)

    @my_words = Word.joins(:categories)
                     .where("categories.id = #{params[:category_id]}")
                     .joins(:users)
                     .where("users.id = #{current_user.id}")
                     .order("users_words.created_at DESC")
                     .first(10)
  end

  def learnt_words
    # Lay du lieu filter & search cua user
    @category_id = params[:category_id].to_i
    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]


    @categories = Category.select(:id, :name)
    @words = current_user.words
                         .search(@search_key)
                         .order("words.word #{@order == "za" ? "DESC" : "ASC"}")
    @words = @words.joins(:categories).where("categories.id = #{@category_id}") unless @category_id == 0               
    @words = @words.paginate(page: params[:page], :per_page => 10)
  end
end
