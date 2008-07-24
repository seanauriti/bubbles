require File.dirname(__FILE__) + '/../test_helper'

class BubbleTest < ActiveSupport::TestCase
  fixtures :bubbles, :users

  def test_should_create_bubble
    assert_difference 'Bubble.count' do
      bubble = create_bubble 
      assert !bubble.new_record?
    end
  end
  
  def test_should_not_allow_blank_bodies
    bubble = create_bubble(:body => '')
    assert bubble.new_record?
    assert !bubble.valid?
  end 
  
protected
  def create_bubble(options = {})
    record = Bubble.new({ :body => 'test bubble', :user => users(:quentin)}.merge(options))
    record.save
    record
  end
end
