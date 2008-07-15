require 'syntax/convertors/html' 
require 'syntaxi'
Syntaxi::line_number_method = 'floating'

class Bubble < ActiveRecord::Base 
  belongs_to :user

  def converted_body
    #convertor = Syntax::Convertors::HTML.for_syntax "ruby"  
    #convertor.convert(self.body) if self.body
    Syntaxi.new(body).process
  end
  
  def expire
    self.solved = true
    self.expire_at = Time.now
    save
  end 
  
  def self.find_solved_since(last_retrieval)
    self.find(:all, :conditions => ["expire_at > ?", last_retrieval])
  end
  
  def self.find_new_since(last_retrieval)
    self.find(:all, :conditions => ["created_at > ?", last_retrieval])
  end
  
end
