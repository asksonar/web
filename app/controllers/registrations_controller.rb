class RegistrationsController < Devise::RegistrationsController
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
