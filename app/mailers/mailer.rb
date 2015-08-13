class Mailer < ApplicationMailer
  def welcome_email(resource)
    @resource = resource
    mail(to: @resource.email, subject: 'Welcome to Sonar!')
  end
end
