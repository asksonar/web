class InvitationsController < Devise::InvitationsController
  def create
    self.resource = User.find_by_email(params["user"]["email"])

    # reactivate account if user has been marked as deleted
    if resource && !resource.deleted_at.nil?
      resource.update_attribute(:deleted_at, nil)
      render json: {
        user: {
          full_name: resource.full_name,
          email: resource.email,
          is_admin: resource.admin?,
          id: resource.id
        },
        notify: resource.full_name + " has been added back to your organization"
      }
    elsif resource
      resource.errors.add(:base, "You have already added or invited this user to your organization")
      render json: { errors: resource.errors.full_messages }, :status => 400
    else
      # lines 19-27 taken from Devise::InvitationsController lines 17-25
      self.resource = invite_resource
      resource_invited = resource.errors.empty?

      yield resource if block_given?

      if resource_invited
        if is_flashing_format? && self.resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, :email => self.resource.email
        end
        render json: {
          invited_user: {
            email: resource.email,
            is_admin: resource.admin?,
            id: resource.id
          },
          notify: "An invitation email has been sent to " +  resource.email
        }
      else
        render json: { errors: resource.errors.full_messages }, :status => 400
      end
    end
  end
end
