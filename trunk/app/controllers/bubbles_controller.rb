class BubblesController < ApplicationController
  before_filter :login_required
  
  def index   
    @bubbles = Bubble.paginate :page => params[:page], :order => 'created_at DESC', :conditions => 'expire_at IS NULL'
    update_last_retrieval_time
  end
  
  def list
    @user = User.find_by_login(params[:id])
    @bubbles = Bubble.by_user(@user.id)
    render :action => "index"
  end  
  
  def search
    results = Bubble.find_by_solr(params[:q])
    if results.total > 0
      @bubbles = results.docs
    end
    render :action => "index" 
  end
  
  def new
    @bubble = Bubble.new
  end  
  
  def create
    @bubble = Bubble.create(params[:bubble].merge(:user => current_user))
    puts "#{params[:bubble].merge( :user_id => current_user.id, :solved => false )}"

    if @bubble.errors.empty?
      update_last_retrieval_time  
      flash[:success] = 'Your bubble creation was successful'
      redirect_to bubbles_path
    else
      flash[:error] = 'lack of success'
    end   
  end
  
  def destroy
    @bubble = Bubble.find(params[:id])
    @bubble.expire
    render :update do |page|
      page.visual_effect :fade, dom_id(@bubble)
    end
  end 
  
  def refresh_bubbles
    render :nothing => true and return unless bubbles_need_update?
    render :update do |page| 
      @expired_bubbles.each do |b|
        page.visual_effect :fade, dom_id(b) 
      end         

      @new_bubbles.each do |n|
        page.insert_html :after, 'update_placeholder', :partial => 'bubble', :object => n
        page.visual_effect :highlight, dom_id(n), :duration => 2
      end          
    end 

    update_last_retrieval_time  
  end 
  
  private 
    def bubbles_need_update?
      @expired_bubbles = Bubble.solved_since(session[:last_retrieval])
      @new_bubbles = Bubble.created_since(session[:last_retrieval])
      !@expired_bubbles.empty? || !@new_bubbles.empty?
    end        
  
end
