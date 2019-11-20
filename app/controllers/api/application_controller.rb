class Api::ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, {fallback: :none, unless: :no_authentication_required}

  respond_to :json

  private
  def paginate_list(total_item, page, per_page)
    return { 
             paginate: {
              total_item: total_item, 
              previous_page: (page.to_i == 1 ? false : page.to_i - 1), 
              current_page: page.to_i,
              next_page: ( total_item - (per_page.to_i * page.to_i) > 0 ? page.to_i + 1 : false ), 
              last_page: (total_item.to_f / per_page).ceil
             },
             list: []
            }
  end
  def render_json(data, status = "success", message = "", code = 200)
    render json:
      { status: status, message: message, data: data }, status: code
  end

  def ensure_token_exist
    render_json("", "error", "Authorization Token is required!", 401) if request.headers["Authorization"].nil?
  end

  def current_user
    @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
  end

  def authenticate_user_from_token
    render_json("", "error", "You are not authenticated!", 401) if current_user.nil?
  end

  def ensure_params_exist
   return unless params[:user].blank?
    render_json("", "error", "Missing params!", 422)
  end

  def load_user_authentication
    @user = User.find_by_email user_params[:email]
    return login_invalid unless @user
  end

  def login_invalid
    render_json("", "error", "Invalid login!", 200)
  end

  def no_authentication_required
    self._process_action_callbacks.map {|c| c.filter }.compact.include? :no_authentication_required
  end
end