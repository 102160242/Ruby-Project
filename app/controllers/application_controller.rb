class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
  
    def configure_permitted_parameters
      added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def show_404_error
      render file: Rails.public_path.join("404.html"), layout: false
    end

    def admin_user
      show_404_error unless current_user.admin?
    end 
end
