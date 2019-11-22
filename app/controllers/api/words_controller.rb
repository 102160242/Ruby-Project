class Api::WordsController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token

    def index
        @category = Category.find_by(id: params[:category_id])
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:search].nil? ? 1 : params[:page]
        @per_page = 10
        @filter = params[:filter]

        @words = Word.joins(:categories)
                    .where("categories.id = #{params[:category_id]}")
                    .where("word LIKE ?", "%#{@search_key}%")
                    .select("id", "word", "word_class", "ipa", "meaning")
                    .order("word #{@order}")
                    # .learnt(current_user.id, false)
        if @filter == "learnt"
            @words = @words.learnt(current_user.id, true)
        end
        if @filter == "unlearnt"
            @words = @words.learnt(current_user.id, false)
        end
        # if @filter == "learnt" || @filter == "unlearnt"
        #     @words = Word.learnt(current_user.id, @filter == "learnt")
        # end

        @returnData = paginate_list(@words.length, @page, @per_page)
        @words = @words.paginate(page: @page, :per_page => @per_page)

        @words_json = @words.as_json
        @learnt_words = current_user.words 

        @words.each_with_index do |i, index|
            @words_json[index]["word_class"] = Word.word_class_name(i["word_class"])
            @words_json[index][:img_url] = url_for(i.image.variant(resize: "500x500"))
            if(@learnt_words.include?(i))
                @words_json[index][:learnt] = true
            else
                @words_json[index][:learnt] = false
            end
        end
        #@words_json = []

        @returnData["list"] = @words_json
        @returnData["category_name"] = @category.name
        render_json(@returnData)
    end

    def learntword
        begin
            @word = Word.find(params[:id])
            current_user.words << @word
            render_json("", "success", "learnt word " + @word.word + "!")
        rescue => e
            render_json("", "error", "There was an error while attemping to learnt this word!" + e)
        end
    end

    def unlearntword
        begin
            @word = Word.find(params[:id])
            current_user.words.delete(@word)
            render_json("", "success", "unlearnt word " + @word.word + "!")
        rescue => e
            render_json("", "error", "There was an error while attemping to unlearnt this word!" + e)
        end
    end

    def myword
        @category_id = params[:category_id].to_i
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:search].nil? ? 1 : params[:page]
        @per_page = 10

        @words = current_user.words
                        .where("word LIKE ?", "%#{@search_key}%")
                        .select("id", "word", "word_class", "ipa", "meaning")   
                        .order("word #{@order}")
        @words = @words.joins(:categories).where("categories.id = #{@category_id}") unless @category_id == 0

        @returnData = paginate_list(@words.length, @page, @per_page)
        @words = @words.paginate(page: @page, :per_page => @per_page)

        @categories_json = Category.select(:id, :name).as_json
        @words_json = @words.as_json

        @words.each_with_index do |i, index|
            @words_json[index]["word_class"] = Word.word_class_name(i["word_class"])
            @words_json[index][:img_url] = url_for(i.image.variant(resize: "500x500"))
            @words_json[index][:learnt] = true
        end
        @returnData["list"] = @words_json
        @returnData["category_data"] = @categories_json
        render_json(@returnData)
    end
end
