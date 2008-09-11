class BubblesController < ApplicationController 
  include SyntaxFormatting
  before_filter :login_required
  
  def index   
    @bubbles = Bubble.paginate_unsolved :page => params[:page], :order => 'created_at DESC'
    update_last_retrieval_time
    respond_to do |format|
      format.html
      format.xml { render :xml => @bubbles }
    end
  end
  
  def list
    @user = User.find_by_login(params[:id])
    @bubbles = Bubble.by_user(@user)     
    render :action => "index"
  end
  
  def show
    @bubble = Bubble.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @bubble }
    end  
  end  
  
  def search
    results = Bubble.find_by_solr(params[:q])
    if results.total > 0
      @bubbles = results.docs
      @bubbles.paginate :page => params[:page]
    end
    render :action => "index" 
  end
  
  def new
    @bubble = Bubble.new
    respond_to do |format|
      format.html
      format.xml { render :xml => @person }
    end
  end                            
  
  def compose
    @bubble = Bubble.new
  end
  
  def edit
    @bubble = Bubble.find(params[:id])
  end
  
  def append
    body_build   = params[:entry_type] == "code" ? delimited(params[:body]) : params[:body]
    preview_pane = params[:entry_type] == "code" ? format_syntax(delimited(params[:body])) : params[:body]   
    respond_to do |format|
      format.js {
        render :update do |page|
          page.insert_html :bottom, 'final_bubble_body',   body_build
          page.insert_html :bottom, 'bubble_working_area', preview_pane
        end
      #render :text => @bubble.converted_body
      }
    end       
  end
  
  def create
    @bubble = Bubble.create({:body => params[:final_body]}.merge(:user => current_user))
    respond_to do |format|
      if @bubble.errors.empty?
        update_last_retrieval_time  
        flash[:success] = 'Your bubble creation was successful'
        format.html { redirect_to bubbles_path }
        format.xml  { render :xml => @bubble, :status => :created, :location => @bubble }
      else
        flash[:error] = 'lack of success'
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end 
    end  
  end
  
  def update
    @bubble = Bubble.find(params[:id])
    @user   = User.find(current_user)
    @bubble.append(params[:final_body].to_s, @user)
    puts "******crrent user = #{@user.login}*******here is the params#{params[:final_body]}" 
    unless @bubble.save then puts "#{@bubble.errors}"  end
    puts "here's what's in the bubble #{@bubble.inspect}"
    redirect_to bubbles_path
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
         page << "if ($('#{dom_id(b)}') != null) { "
         page.visual_effect :fade, dom_id(b) 
         page << " } "
      end         

      @new_bubbles.each do |n|
        page.insert_html :after, 'update_placeholder', :partial => 'bubble', :object => n
        page.visual_effect :highlight, dom_id(n), :duration => 2
      end          
    end 

    update_last_retrieval_time  
  end
  
  def help
  end
  
  private 
    def bubbles_need_update?
      @expired_bubbles = Bubble.solved_since(session[:last_retrieval])
      puts "solved since : #{session[:last_retrieval]} - there are #{@expired_bubbles.count}"
      @new_bubbles = Bubble.created_since(session[:last_retrieval])
      !@expired_bubbles.empty? || !@new_bubbles.empty?
    end        
  
end
