require File.dirname(__FILE__) + '/../test_helper'

class BubbleTest < Test::Unit::TestCase 

  context "A Bubble instance" do
    setup do
      b = Factory(:bubble)
    end
    
    should_ensure_length_at_least :body, 1  
  end
  
end
