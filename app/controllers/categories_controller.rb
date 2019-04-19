class CategoriesController < ApplicationController
  #before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
    @categories = Category.search(@search_key)
                          .order("name #{@order == "za" ? "DESC" : "ASC"}")
                          .paginate(page: params[:page], :per_page => 6)
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
