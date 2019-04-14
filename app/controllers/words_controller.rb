class WordsController < ApplicationController
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

    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @filter = (params[:filter].nil? || params[:filter] == "") ? "" : params[:filter]

    @words = Word.joins(:categories)
                 .where("categories.id = #{params[:category_id]}")
                 .search(@search_key)
                 .filter_(@filter, current_user.id)
                 .paginate(page: params[:page], :per_page => 10)

    @my_words = Word.joins(:categories)
                     .where("categories.id = #{params[:category_id]}")
                     .joins(:users)
                     .where("users.id = #{current_user.id}")
                     .order("users_words.created_at DESC")
                     .first(10)
  end
end
