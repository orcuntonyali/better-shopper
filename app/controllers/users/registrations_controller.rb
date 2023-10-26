module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, if: :devise_controller?

    def update
      super # Retain Devise's original functionality

      # Add your custom logic for debugging the location
      puts "Debugging user location: #{current_user.location}"
    end

    def set_max_distance
      if user_signed_in?
        current_user.update(max_distance: params[:max_distance])
        render json: { status: 'success', max_distance: params[:max_distance] }
      else
        render json: { status: 'failure', message: 'User not signed in' }, status: 401
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :latitude, :longitude, :max_distance])
      devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :latitude, :longitude, :max_distance])
    end
  end
end
