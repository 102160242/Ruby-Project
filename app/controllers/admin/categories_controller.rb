class Admin::CategoriesController < ApplicationController
  layout "admin/layouts/application"

  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :admin_user
    
  # GET /categories
  # GET /categories.json
  def index
    #@categories = Category.all.paginate(page: params[:page], :per_page => 6)
    @search_key = (params[:search_key].nil? || params[:search_key] == "") ? "" : params[:search_key]
    @order = (params[:order].nil? || params[:order] == "") ? "" : params[:order]
    @categories = Category.search(@search_key)
                          .order("name #{@order == "za" ? "DESC" : "ASC"}")
                          .paginate(page: params[:page], :per_page => 6)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show

  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: admin_categories_path }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_categories_path }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    respond_to do |format|
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully destroyed.' }
        format.json { head :no_content }
    end
  end
  #def destroy
    #@category = Category.find(params[:id])
    #@category.destroy
    #respond_to do |format|
     # format.html { redirect_to admin_categories_url, notice: 'Category was successfully destroyed.' }
      #format.json { head :no_content }
    #end
  #end

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
