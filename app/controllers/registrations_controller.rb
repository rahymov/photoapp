class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  def create
    build_resource(sign_up_params)
    
    resource.class.transaction do
      resource.save
      yield resource if block_given?
      if resource.persisted?
        @payment = Payment.new({ email: params["user"]["email"], 
          token: params[:payment]["token"], user_id: resource.id })
        
        flash[:error] = "Please check registration errors" unless @payment.valid?
        
        begin
          @payment.process_payment
          @payment.save
        rescue Exception => e 
          flash[:error] = e.message
          
          resource.destroy
          puts 'Payment failed'
          render :new and return
        end
        
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      redirect_to new_user_session_path
      #respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit({ roles: [] }, :email, :password, :password_confirmation) }
  end
end