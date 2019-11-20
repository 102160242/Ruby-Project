class Api::CategoriesController < Api::ApplicationController
    before_action :no_authentication_required
    respond_to :json
    def index
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:page].nil? ? 1 : params[:page]
        @per_page = 6

        @categories = Category.select("id", "name").where("name LIKE ?", "%#{@search_key}%").order("name #{@order}")

        @returnData = paginate_list(@categories.length, @page, @per_page)
        @categories = @categories.paginate(page: @page, :per_page => @per_page)

        @jsonData = []
        @categories.each do |i|
        #p i.image.variant(resize: "500x500")
        @jsonData << {:id => i.id, :name => i.name, :image_url => url_for(i.image.variant(resize: "500x500")), :total_words => i.words.count}
        end
        
        @returnData["list"] = @jsonData
        render_json(@returnData) 
    end
end
