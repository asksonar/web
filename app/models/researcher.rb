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

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'M7k&59nN$XjZ'

  attr_accessor :current_password

  private

  def default_values
    self.has_v1 = false if has_v1.nil?
    self.has_v2 = true if has_v2.nil?
  end

  def create_company
    self.company = Company.create
  end

  def track_researcher_created
    Analytics.instance.researcher_created(self)
  end

  def welcome_email
    Mailer.welcome_email(self).deliver_now
  end

  def subscribe_mailing_list
    Resque.enqueue(SubscribeMailingListWorker, email, 'alpha_users')
  end
end
