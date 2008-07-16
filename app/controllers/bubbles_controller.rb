class BubblesController < ApplicationController
  before_filter :login_required
  
  def index   
    @bubbles = Bubble.find_all_by_solved(false, :order => 'created_at DESC') 
  end
  
  def list
    @bubbles = Bubble.find_all_by_user_id(User.find_by_login(params[:id]), :order => 'created_at DESC')
    render :action => "index"
  end
  
  def new
    @bubble = Bubble.new
  end  
  
  def create
    @bubble = Bubble.new(params[:bubble])
    @bubble.user = current_user
    @bubble.solved = false
    @bubble.save 
    session[:last_retrieval] = @last_retrieval = Time.now
    redirect_to bubbles_path
  end
  
  def destroy
    @bubble = Bubble.find(params[:id])
    @bubble.expire
    #@bubble.destroy
    render :update do |page|
      page.visual_effect :fade, dom_id(@bubble)
    end
  end
  
  def refresh_bubbles
    last_retrieval = session[:last_retrieval]
    @expired_bubbles = Bubble.find_solved_since(last_retrieval)
    @new_bubbles = Bubble.find_new_since(last_retrieval)
    session[:last_retrieval] = @last_retrieval = Time.now 
    if !@expired_bubbles.empty? || !@new_bubbles.empty?
      render :update do |page|
        unless @expired_bubbles.empty?
          @expired_bubbles.each do |b|
            page.visual_effect :fade, dom_id(b) 
          end
        end
        unless @new_bubbles.empty?
          @new_bubbles.each do |n|
            page.insert_html :top, 'update_placeholder', :partial => 'bubble', :object => n
            page.visual_effect :highlight, 'update_placeholder', :duration => 2
          end
        end 
      end
    else
      render :text => ''
    end
    
  end 
      
  
end
