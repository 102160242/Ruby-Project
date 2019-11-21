class Api::Admin::CategoriesController < Api::ApplicationController
    before_action :current_category, except: [:create] 
    respond_to :json
    def index
        @search_key = (params[:search].nil? || params[:search] == "") ? "" : params[:search]
        @order = (params[:order].nil? || params[:order] == "") ? "ASC" : params[:order]
        @page = params[:page].nil? ? 1 : params[:page]
        @per_page = params[:per_page].nil? ? 10 : params[:per_page]

        @categories = Category.select("id", "name").where("name LIKE ?", "%#{@search_key}%").order("name #{@order}")

        @returnData = paginate_list(@categories.length, @page, @per_page)
        @categories = @categories.paginate(page: @page, :per_page => @per_page)

        @jsonData = []
        @categories.each do |i|
        #p i.image.variant(resize: "500x500")
        @image_url = i.image.attached? ? url_for(i.image.variant(resize: "500x500")): "";
        @jsonData << {:id => i.id, :name => i.name, :image_url => @image_url, :total_words => i.words.count}
        end
        
        @returnData["list"] = @jsonData
        render_json(@returnData) 
    end

    def destroy
        if(@category.nil?)
            render_json("", "error", "Couldn't find the category you're trying to delete!")
        else
            @category.destroy
            render_json("", "success", "Deleted category #{@category.name} successfully!")
        end
    end

    def create
        @category = Category.new(category_params)
        begin
            if @category.save
                render_json("", "success", "Created new category successfully!")
            else
                render_json("", "error", @category.errors.messages)
            end
        rescue Exception
            #p @category.errors
            render_json("", "error", @category.errors.messages)
            raise
        end
      end

    private
      def current_category
        @category ||= Category.find_by(id: params[:category_id])
      end
      def category_params
        params.require(:category).permit(:name, :image)
      end
end
