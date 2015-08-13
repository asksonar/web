# Preview all emails at http://localhost:3000/rails/mailers/mailer
class MailerPreview < ActionMailer::Preview
  def welcome_email
    Mailer.welcome_email(Researcher.first)
  end
end
