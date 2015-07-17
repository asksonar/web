class Researcher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  before_create :create_company
  validates_presence_of :full_name

  def is_researcher?
    true
  end

  private
    def create_company
      self.company = Company.create();
    end

end
