class InvitationsController < Devise::InvitationsController
  # POST /resource/invitation
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      render :json => { id: resource.id, is_admin: resource.admin? }
    else
      render :json => { errors: resource.errors.full_messages }, :status => 400
    end
  end
end
