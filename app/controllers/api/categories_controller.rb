class Api::CategoriesController < Api::ApplicationController
    respond_to :json
    def index
        @categories = Category.select("id", "name").order("name")
                             
        @jsonData = []
        @categories.each do |i|
        p i.image.variant(resize: "500x500")
        @jsonData << {:id => i.id, :name => i.name, :image_url => url_for(i.image.variant(resize: "500x500")), :total_words => i.words.count}
        end
          
        render_json(@jsonData) 
    end
end
