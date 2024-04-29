class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource) 

    if resource.is_a?(User)
      if current_user.venue
        venue_path(current_user.venue.id)
      else
        new_venue_path
      end
    else
      super
    end

  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

end
