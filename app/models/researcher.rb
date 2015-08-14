class Researcher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company

  before_create :create_company
  after_create :track_researcher_created
  after_create :welcome_email
  after_create :subscribe_mailing_list

  validates_presence_of :full_name

  enum role: [:user, :admin, :super_admin]

  HASHIDS_SALT = 'M7k&59nN$XjZ'

  private
    def create_company
      self.company = Company.create();
    end

    def track_researcher_created
      Analytics.instance.researcher_created(self)
    end

    def welcome_email
      Mailer.welcome_email(self).deliver_now
    end

    def subscribe_mailing_list
      MailchimpUtility.instance.subscribe_alpha_users(self.email)
    end

end
