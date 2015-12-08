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

    if !params[:password].blank? && !params[:password_confirmation].blank?
      current_password = params.delete(:current_password)
      result = if resource.valid_password?(current_password)
        resource.update_attributes(params)
      else
        resource.assign_attributes(params)
        resource.valid?
        resource.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    else
      result = resource.update_attributes(params)
    end

    resource.clean_up_passwords
    result
  end
end
