class User < ActiveRecord::Base  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_one :mobile_phone
  has_many :phones
  has_one :home_address
  has_one :mailing_address
  has_many :addresses
  
  before_create :normalize
  
  def type_setter=(type_name)
    self[:type]=type_name
  end
  
  private
  
  def normalize
    self.email = self.email.downcase if self.email
    self.name = self.name.titleize if self.name
    self.sex = self.sex.to_sex if self.sex
  end
  
end
