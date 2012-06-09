require 'open-uri'

class Resource < ActiveRecord::Base
  #Tire gem
  include ConstantsHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name BONSAI_INDEX_NAME

  #Note: Because we are using nested form, we can not add any validators to the attachments attribute
  attr_accessor :agreed
  attr_accessible :description, :title, :attachments_attributes, :user_id, :views, :agreed, :topic_tokens

  belongs_to :user
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :user_resource_views, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :resource_topics
  has_many :topics, through: :resource_topics

  accepts_nested_attributes_for :attachments, :allow_destroy => true
  attr_reader :topic_tokens


  before_create :extract_content

  mapping do
    indexes :title, type: 'string', :store => true
    indexes :description, type: 'string', :store => true
    indexes :extracted_content, type: 'string', :analyzer => 'snowball', :store => true
    indexes :author, type: 'string', :index => :not_analyzed, :store => true 
    indexes :views, type: 'integer', :index => :not_analyzed, :store => true
    indexes :topic_tags, :store => true
  end

  #before_create :clear_nil_attachments
  validates_presence_of :user_id
  validates_presence_of :description, :message => "Resource must have a description"
  validates             :description, :length => {:minimum => RESOURCE_DESCRIPTION_MIN_LENGTH}
  validates_presence_of :title, :message => "Resource must have a title"
  validates             :title, :length => {:minimum => RESOURCE_TITLE_MIN_LENGTH}
  #validates_with ResourceValidator

  def topic_tokens=(tokens)
    self.topic_ids = Topic.ids_from_tokens(tokens)
  end

  def self.search(params)
    search_query = params[:query]
    UserQuery.create(:content => params[:query]) if ((!search_query.nil?) && (!search_query.empty?))
    tire.search(per_page: 15) do |s|
      s.query do |q|
        q.boolean do |b|
          b.should{ string "#{params[:query]}"} if params[:query].present? 
          b.should{ string "#{params[:query]}", default_field: 'extracted_content', analyzer: 'snowball'} if params[:query].present? 
          #b.must{ term :search_topic_tags, params[:current_resource_topics] } if params[:current_resource_topics].present?
        end
      end
      s.highlight :title, :description, :extracted_content, :author, :topic_tags, :search_topic_tags, :options => {:tag => '<span class="resource_highlight">'}
=begin
      s.facet "resource_topics" do
        terms :search_topic_tags
      end
=end

      logger.debug "\n\n=======curl: #{s.to_curl}\n"
    end
  end


  def to_indexed_json
    to_json(methods: [:author, :attachment_count, :topic_tags, :search_topic_tags])
  end

  def author
    user.screen_name
  end

  def attachment_count
    attachments.count
  end

  def topic_tags
    @topics = []
    self.topics.each{|topic| @topics << topic.name.to_s}
    @topics.join(" ")
  end

  def search_topic_tags
    @topics = []
    self.topics.each{|topic| @topics << topic.name.to_s}
    @topics
  end

  def extract_content
    # encoding: utf-8
    #puts "\n\nextracting content....\n"
    content = []
    attachments.each do |attachment|
      if attachment.file.extension == FILE_EXTENSION_DOC
        #doc = MSWordDoc::Extractor.load(attachment.file.current_path)
        doc = MSWordDoc::Extractor.load(attachment.file_url)
        content << doc.whole_contents   # doc is MSWordDoc::Essence
        doc.close() 
      elsif attachment.file.extension == FILE_EXTENSION_DOCX
        #doc, thumbnail = Hypodermic.extract('path/to/document', :thumbnail => true)
        #content <<  Hypodermic.extract(attachment.file.current_path)
        #d = Docx::Document.open(attachment.file.current_path)
        d = Docx::Document.open(attachment.file_url)
        d.each_paragraph{|p| content << p}
          #content
        #end
      elsif attachment.file.extension == FILE_EXTENSION_PDF
        #reader = PDF::Reader.new(attachment.file.current_path, 'rb')
        reader = PDF::Reader.new(attachment.file_url, 'rb')
        reader.pages.each do |page|
          content << page.text
          #page.text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          #page.text.encode!('UTF-8', 'UTF-16')
        end
      elsif attachment.file.extension == FILE_EXTENSION_RTF
        #doc = RubyRTF::Parser.new.parse(File.open(attachment.file.current_path).read)
        doc = RubyRTF::Parser.new.parse(File.open(attachment.file_url).read)
        doc.sections.each{|section| content << section[:text]}
      elsif attachment.file.extension == FILE_EXTENSION_TXT
        #logger.debug("\n====tempfile: #{attachment.file_url}\n")
        #puts "#{attachment.methods.sort.join("\n")}"
        #f = File.open(attachment.file.current_path).each do |line|
        f = File.open(attachment.file_url).each do |line|
          #logger.debug "===content: #{line}"
          #line.strip!
          content << line.strip
          #logger.debug "===after content: #{content}"
        end
        f.close
        #logger.debug "===text extraction: #{content}"
      end
=begin
      yomu = Yomu.new "#{attachment.file.current_path}"
      doc_content = yomu.text.strip
      content << doc_content
=end
    end
    #self.extracted_content = content.join(" ") unless content.empty?
    #puts "====before content: #{content}\n"
    unless content.empty?
      extracted_content = content.join(" ")
      self.extracted_content = extracted_content.gsub(/\\r\\n/," ") 
    end
    #puts "====after content: #{self.extracted_content}\n"
  end
=begin
  def clear_nil_attachments
    if(self.attachments.kind_of?(Array))
      self.attachments.delete_if {|attachment| attachment.file.identifier.nil?}
    end
  end
=end
end
