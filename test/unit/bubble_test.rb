require File.dirname(__FILE__) + '/../test_helper'

class BubbleTest < Test::Unit::TestCase

  should_ensure_length_at_least :body, 1
  should_belong_to              :user   

  context "A Bubble instance" do
    setup do
      @b = Factory(:bubble)
    end
    
    context "on append" do
      setup do
        @b.append('this is what i am appending', Factory(:user))
      end
      
      should "have an appended body" do
        assert_match /appending/, @b.body
      end
    end
  end
  
end
