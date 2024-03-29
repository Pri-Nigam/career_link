class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :after_sign_up
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: {warning: exception, status: "Authorization failed"}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:password,:role])
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if current_user.client?
      client_path(id: current_user.id)
    else 
      jobs_path
    end
  end

  def after_sign_up
    if user_signed_in? && current_user.client?
      clients_url
    else 
      jobs_path
    end
  end
end
