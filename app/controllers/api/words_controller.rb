class Api::WordsController < Api::ApplicationController
    before_action :ensure_token_exist, :authenticate_user_from_token

    def index
        @category = Category.find_by(id: params[:category_id])

        @words = Word.joins(:categories)
                    .where("categories.id = #{params[:category_id]}")
                    .select("id", "word", "word_class", "ipa", "meaning")
                    .order("word ASC")
        @words = @words.paginate(page: params[:page], :per_page => 10)
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

        render_json(@words_json)
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
end
