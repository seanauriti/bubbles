class Bubble < ActiveRecord::Base 
  
  belongs_to :user
  before_create :set_defaults
  validates_length_of :body, :minimum => 1
  
  named_scope :find_all,       :order      =>  'created_at DESC',    :include => :user
  named_scope :find_solved,    :conditions => ['expire_at < NOW()'], :include => :user
  named_scope :find_unsolved,  :conditions => ['expire_at > NOW()'], :include => :user, :order => 'updated_at DESC'   
  
  named_scope :by_user,       lambda { |user|     { :conditions => ["user_id    = ?", user.id  ], :order => "created_at DESC", :include => :user }}       
  named_scope :solved_since,  lambda { |since_dt| { :conditions => ["expire_at  < ?", since_dt + 5.seconds ], :order => "created_at DESC"} } 
  named_scope :created_since, lambda { |since_dt| { :conditions => ["created_at > ?", since_dt ], :order => "created_at DESC"} }   
  
  acts_as_solr
  
  # def replace_delimiters  
  #   body.gsub!(/[\*]{3}(ruby|css|html|javascript|js|pl|perl)/,"[code lang=\"" + '\1' + "\"]") 
  #   body.gsub!(/[\*]{3}/,"[/code]")
  # end     
  
  # def converted_body
  #   #replace_delimiters
  #   format_syntax(body)
  # end
  # 
  # def add_code(code, lang='ruby')
  #   body << "[code lang=#{lang}]#{code}[/code]"
  # end
  # 
  # def add_text(text)
  #   body << text
  # end     
  
  def append(reply, author)
    self.body += "\n<< #{author.login} says ...\n" 
    self.body += "\n#{reply}\n" 
    self.save!
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
end
