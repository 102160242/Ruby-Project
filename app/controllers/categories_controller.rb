class CategoriesController < ApplicationController
  #before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
    @categories = Category.search(@search_key)
                          .select("id", "name")
                          .order("name #{@order == "za" ? "DESC" : "ASC"}")
    # Neu khong co params all thi tra du lieu theo paginate                      
    @categories = @categories.paginate(page: params[:page], :per_page => 6) if(params[:all].nil? || params[:all] != "true")
                         
    respond_to do |format|
      format.html

      @jsonData = []
      @categories.each do |i|
        p i.image.variant(resize: "500x500")
        @jsonData << {:id => i.id, :name => i.name, :image_url => url_for(i.image.variant(resize: "500x500")), :total_words => i.words.count}
      end
      
      format.json { render :json => { status: :success, data: @jsonData } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :image)
    end
end
