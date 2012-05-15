class Topic < ActiveRecord::Base
  attr_accessible :name
  has_many :resource_topics
  has_many :resources, through: :resource_topics
  validates_presence_of :name, :allow_nil => false
  validates_uniqueness_of :name, :allow_blank => false, :allow_nil => false

  def self.tokens(query)
    topics = where("name like ?", "%#{query}%")
    if topics.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      topics
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
