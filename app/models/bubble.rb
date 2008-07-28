require 'syntax/convertors/html' 
require 'syntaxi'
Syntaxi::line_number_method = 'floating'

class Bubble < ActiveRecord::Base 
  belongs_to :user
  before_create :set_defaults
  validates_length_of :body, :minimum => 1
  
  acts_as_solr
  
  def converted_body  
    body.gsub!(/[\*]{3}(ruby|css|html|javascript|js)/,"[code lang=\"" + '\1' + "\"]") 
    body.gsub!(/[\*]{3}/,"[/code]")  

    Syntaxi.new(body).process   
  end
  
  def count_code_delimiters
    body.to_a.map{ |l| l.chomp =~ /code:(ruby|css|html|javascript|js)$/ }.compact.size
  end
  
  def expire
    self.solved = true
    self.expire_at = Time.now
    save
  end 
  
  def self.find_solved_since(last_retrieval)
    self.find(:all, :conditions => ["bubbles.expire_at > ?", last_retrieval], :include => :user)
  end
  
  def self.find_new_since(last_retrieval)
    self.find(:all, :conditions => ["bubbles.created_at > ?", last_retrieval], :include => :user)
  end
  
  protected
  
    def set_defaults
      self.solved = false 
      return true
    end
  
end
