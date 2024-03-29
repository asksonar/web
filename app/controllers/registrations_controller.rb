class RegistrationsController < Devise::RegistrationsController

  # copied from
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb#L64
  # then modified to soft_delete instead of destroy
  def destroy
    resource.soft_delete # resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

  def update_resource(resource, params)
    params_stripped = params.select { |_key, value| !value.blank? }

    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params_stripped)
    else
      super(resource, params_stripped)
    end
  end
end
