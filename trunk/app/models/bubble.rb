require 'syntax/convertors/html' 
require 'syntaxi'
Syntaxi::line_number_method = 'floating'

class Bubble < ActiveRecord::Base 
  belongs_to :user
  before_create :set_defaults
  after_create :send_im
  validates_length_of :body, :minimum => 1
  
  named_scope :find_all, :order => 'created_at DESC', :include => :user
  named_scope :solved, :conditions => ['expire_at IS NOT NULL'], :include => :user
  named_scope :find_unsolved,  :conditions => ['expire_at IS NULL'], :include => :user, :order => 'created_at DESC'
  named_scope :by_user,  lambda { |user|  { :conditions => ["user_id = ?", user.id ], :order => "created_at DESC", :include => :user }}       
  named_scope :solved_since,  lambda { |since_dt| { :conditions => ["expire_at  > ?", since_dt ], :order => "created_at DESC"} } 
  named_scope :created_since, lambda { |since_dt| { :conditions => ["created_at > ?", since_dt ], :order => "created_at DESC"} }   
  
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
  
  protected
  
    def set_defaults
      self.solved = false 
      return true
    end
    
    def send_im
      client = Net::TOC.new("aibubblesbot", "listerine!")
      client.connect
      
      ['kylenicholas7'].each do |buddy|
        buddy = client.buddy_list.buddy_named("kylenicholas7")
        buddy.send_im("#{self.user.aim} just created a bubble.")
      end  
    end  
end
