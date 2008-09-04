require File.dirname(__FILE__) + '/../test_helper'
class BubblesControllerTest < ActionController::TestCase

  setup do
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new 
  end
  
  context "GET :index" do
    setup do
      @controller.stubs(:current_user).returns(Factory(:user))     
      get :index
    end
      
    should_assign_to    :bubbles                                
    should_respond_with :success
  end 
  
  context "on Create" do
    setup do
      post :create, :bubble => Factory.attributes_for(:bubble)
    end
    
    should_respond_with :redirect             
  end    
             
  context "on Pop!" do
    setup do
      @controller.stubs(:current_user).returns(Factory(:user)) 
      @bubble1 = Factory(:bubble)
      @bubble2 = Factory(:another_bubble)

      puts "Count => #{@count = Bubble.find_unsolved.count}" 
      post :destroy, :id => @bubble1.id 
    end
    
    should "have one less unsolved bubble" do 
      assert_match /Effect\.Fade/, @response.body           
      assert_equal @count - 1, Bubble.find_unsolved.count   
    end 
  end
  
  # rewrite of the login_as(:user) from AuthenticatedTestHelper, which uses fixtures
  def login_as(user)
    unless @request.session[:user_id] 
      @request.session[:user_id] = Factory(user).id
    end
  end

end
