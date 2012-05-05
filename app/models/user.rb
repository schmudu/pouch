class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :screen_name, :downloads
  # attr_accessible :title, :body

  has_many :resources
  has_many :user_attachment_downloads
  has_many :user_resource_views
  
  validates_uniqueness_of :email
  validates_uniqueness_of :screen_name
  validates_with UserValidator
end
