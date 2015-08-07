class Researcher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  before_create :create_company
  after_create :notify_mixpanel_create
  validates_presence_of :full_name

  enum role: [:user, :admin, :super_admin]

  HASHIDS_SALT = 'M7k&59nN$XjZ'

  private
    def create_company
      self.company = Company.create();
    end

    def notify_mixpanel_create
      Analytics.tracker.track(self.id, 'Researcher Created', {
        'company_id': self.company_id
      })
      Analytics.tracker.people.set(self.id, {
        'full_name'       => self.full_name,
        'company_id'      => self.company_id,
        'email'           => self.email,
        'created_at'      => self.created_at
      });
    end

end
