class RegistrationsController < Devise::RegistrationsController

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

  def after_sign_up_path_for(resource)
    '/results?walkthrough=start'
  end

  def update_resource(resource, params)
    params_stripped = params.select { |key, value| !value.blank? }

    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params_stripped)
    else
      super(resource, params_stripped)
    end
  end
end
