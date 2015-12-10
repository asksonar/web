class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    '/results?walkthrough=start'
  end

  def update_resource(resource, params)
    params.each do |key, value|
      if value.blank?
        params.delete(key)
      end
    end

    if params[:password].nil? && params[:password_confirmation].nil?
      resource.update_without_password(params)
    else
      super
    end
  end
end
