class Resource < ActiveRecord::Base
  #Note: Because we are using nested form, we can not add any validators to the attachments attribute
  attr_accessible :description, :title, :attachments_attributes, :user_id, :views

  belongs_to :user
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :user_resource_views

  accepts_nested_attributes_for :attachments, :allow_destroy => true

  #before_create :clear_nil_attachments
  validates_presence_of :user_id
  validates_presence_of :description, :message => "Resource must have a description"
  validates_presence_of :title, :message => "Resource must have a title"
  #validates_with ResourceValidator

=begin
  def clear_nil_attachments
    if(self.attachments.kind_of?(Array))
      self.attachments.delete_if {|attachment| attachment.file.identifier.nil?}
    end
  end
=end
end
