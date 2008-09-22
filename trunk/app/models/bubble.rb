require 'aim_client'

class Bubble < ActiveRecord::Base 
  
  belongs_to :user
  before_create :set_defaults
  
  after_create :send_new_bubble_notifications
  
  validates_length_of :body, :minimum => 1
  
  named_scope :find_all,       :order      =>  'created_at DESC',    :include => :user
  named_scope :find_solved,    :conditions => ['expire_at < NOW()'], :include => :user
  named_scope :find_unsolved,  :conditions => ['expire_at > NOW()'], :include => :user, :order => 'updated_at DESC'   
  
  named_scope :by_user,       lambda { |user|     { :conditions => ["user_id    = ?", user.id  ], :order => "created_at DESC", :include => :user }}       
  named_scope :solved_since,  lambda { |since_dt| { :conditions => ["expire_at  < ?", since_dt + 5.seconds ], :order => "created_at DESC"} } 
  named_scope :created_since, lambda { |since_dt| { :conditions => ["created_at > ?", since_dt ], :order => "created_at DESC"} }   
  
  acts_as_solr 
  
  LINK_TO_BUBBLES = "check out http://bubbles.alexanderinteractive.com for more details"
  
  def append(reply, author)
    self.body += "\n<< #{author.login} says ...\n" 
    self.body += "\n#{reply}\n" 
    self.save!
    send_replied_to_bubble_notifications
  end 
  
  def expire
    self.solved = true
    self.expire_at = Time.now
    save
  end
  
  protected
    def set_defaults
      self.solved = false
      self.created_at = Time.now
      self.expire_at = 1.day.from_now
    end
    
    def send_new_bubble_notifications
      $client ||= AimClient.new
      User.wanting_notifications.each do |u|
        $client.send_aim(u.aim, "A Bubble has been created - #{LINK_TO_BUBBLES}")
      end
    end
    
    def send_replied_to_bubble_notifications
      $client ||= AimClient.new
      $client.send_aim(self.user.aim, "Someone has replied to your Bubble - #{LINK_TO_BUBBLES}")
    end
end
