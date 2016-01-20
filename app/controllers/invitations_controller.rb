class InvitationsController < Devise::InvitationsController
  def create
    user = User.find_by_email(params["user"]["email"])

    # reactivate account if user has been marked as deleted
    if user && !user.deleted_at.nil?
      user.update_attribute(:deleted_at, nil)
      render json: {
        user: {
          full_name: user.full_name,
          email: user.email,
          is_admin: user.admin?,
          id: user.id
        },
        notify: user.full_name + " has been added back to your organization"
      }
    else
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
