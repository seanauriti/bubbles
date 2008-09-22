require File.dirname(__FILE__) + '/../test_helper'
class BubblesControllerTest < ActionController::TestCase

  context "a bubbles controller " do
    setup do
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      @controller.stubs(:current_user).returns(Factory(:user))   
    end
  
    context "on GET :index" do
      setup { get :index }      
      should_assign_to    :bubbles                                
      should_respond_with :success
    end 
  
    context "on Create" do
      setup { post :create, :bubble => Factory.attributes_for(:bubble)  }
      should_respond_with :success
      
      should "inform others of the bubble" do
      
      end  
    end
  
    context "on Append" do
      setup { xhr :post, :append, :body => 'try to append this' }
      should_respond_with :success
      
      should "get back an Insertion" do
        assert_match /Insertion/, @response.body
      end
      
      should "blank out the textarea" do
        assert_match /body/, @response.body
      end     
    end 
          
    context "on Pop!" do
      setup do
        @bubble1 = Factory(:bubble)
        @bubble2 = Factory(:another_bubble)
        @count = Bubble.count
        post :destroy, :id => @bubble1.id 
      end
    
      should "have one less unsolved bubble" do 
        assert_match /Effect\.Fade/, @response.body           
        assert_equal @count - 1, Bubble.find_unsolved.count   
      end 
    end
  end                
  
  # rewrite of the login_as(:user) from AuthenticatedTestHelper, which uses fixtures
  def login_as(user)
    unless @request.session[:user_id] 
      @request.session[:user_id] = Factory(user).id
    end
  end

end
