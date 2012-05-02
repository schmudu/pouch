class Resource < ActiveRecord::Base
  attr_accessible :description, :title, :attachments_attributes, :user_id

  belongs_to :user
  has_many :attachments, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachments

  before_validation :clear_nil_attachments
  validates_presence_of :user_id
  validates_presence_of :description, :message => "Resource must have a description"
  validates_presence_of :title, :message => "Resource must have a title"
  validates_with ResourceValidator

  def clear_nil_attachments
    if(self.attachments.kind_of?(Array))
      self.attachments.delete_if {|attachment| attachment.file.identifier.nil?}
    end
  end
end
