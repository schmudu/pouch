class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :screen_name, :downloads
  # attr_accessible :title, :body

  has_many :resources, :dependent => :destroy
  has_many :user_attachment_downloads, :dependent => :destroy
  has_many :user_resource_views, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
  validates_uniqueness_of :email
  validates_uniqueness_of :screen_name
  validates_with UserValidator

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password. 
      self.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
    end
  end
end
