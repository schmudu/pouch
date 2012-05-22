class Resource < ActiveRecord::Base
  #Tire gem
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name BONSAI_INDEX_NAME

  #Note: Because we are using nested form, we can not add any validators to the attachments attribute
  attr_accessor :agreed
  attr_accessible :description, :title, :attachments_attributes, :user_id, :views, :agreed, :topic_tokens

  belongs_to :user
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :user_resource_views
  has_many :resource_topics
  has_many :topics, through: :resource_topics

  accepts_nested_attributes_for :attachments, :allow_destroy => true
  attr_reader :topic_tokens


  before_save :extract_content

  mapping do
    indexes :id, type: 'integer', :index => :not_analyzed, :include_in_all => false
    indexes :title, type: 'string', :analyzer => 'snowball', :index => :not_analyzed
    indexes :description, type: 'string', :analyzer => 'snowball'
    #indexes :user_id, type: 'integer', :index => :not_analyzed
    indexes :author, :analyzer => 'keyword'
    #indexes :attachment_count, type: 'integer'
  end

  #before_create :clear_nil_attachments
  validates_presence_of :user_id
  validates_presence_of :description, :message => "Resource must have a description"
  validates_presence_of :title, :message => "Resource must have a title"
  #validates_with ResourceValidator

  def topic_tokens=(tokens)
    #self.topic_ids = ids.split(",")
    self.topic_ids = Topic.ids_from_tokens(tokens)
  end

  def self.search(params)
    tire.search(page: params[:page], per_page: 15) do |s|
      s.query { string params[:query], default_operator: "AND"} if params[:query].present?
      s.filter :term, user_id: params[:user_id] if params[:user_id].present?
      #s.sort {by :title, "asc"} if params[:query].blank?
      s.facet "authors" do
        terms :user_id
      end

      #debugging
      #raise s.to_curl
    end
  end

  def to_indexed_json
    to_json(methods: [:author, :attachment_count])
  end

  def author
    user.screen_name
  end

  def attachment_count
    attachments.count
  end

  private

  def extract_content
    puts "\n\nextracting content....\n"
    content = []
    attachments.each do |attachment|
      if attachment.file.extension == 'pdf'
    puts "it's a pdf\n"
        reader = PDF::Reader.new(attachment.file.current_path)
        reader.pages.each do |page|
    puts "content: #{page.text}\n"
          content << page.text
        end
      end
    end
    puts "final content: #{content.join(' ')}\n\n"
    self.extracted_content = content.join(" ")
  end
=begin
  def clear_nil_attachments
    if(self.attachments.kind_of?(Array))
      self.attachments.delete_if {|attachment| attachment.file.identifier.nil?}
    end
  end
=end
end
