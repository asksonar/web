class Researcher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  before_create :create_company
  after_create :track_researcher_created
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

end
