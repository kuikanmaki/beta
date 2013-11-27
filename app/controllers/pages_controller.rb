class PagesController < ApplicationController

before_filter :require_login, :except => [:show, :index]

  # GET /pages
  # GET /pages.json

  def index
    
    #@pages = Page.all
    #@pages = Page.find_by_sql("select * from pages where id not in (select parentpage_id from pages_parentpages) ORDER BY name") #finds the leaves
    #@pages = Page.find_by_sql("select * from pages where id in (select parentpage_id from pages_parentpages) ORDER BY name") #finds pages with pages under them
    @pages = Page.find_by_sql("select * from pages where id not in (select page_id from pages_parentpages) ORDER BY name") #finds the orphan pages (i.e. major pages)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
      format.json { render json: @parentpages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show

    @page = Page.find(params[:id])
    #@notes = @page.notes.paginate(page: params[:page])

    if @page.present?
      @definition = @page.definition      
      @parentpages = @page.parentpages
      @subpages = @page.subpages
      @relatedpages = @page.relatedpages      
      @notes = @page.notes.paginate(page: params[:page])
      @books = @page.books
      @backlink = params[:backlink]
      @previouspage  = Page.find_by_name(@backlink)
      if current_user.present?
        if @page.users.where(:id => current_user.id).present?
        @follower = true
        else
        @follower = false
        end
      end
    end

    respond_to do |format|
      if @backlink.present?
      flash.now[:notice] = "<span class='glyphicon icon-chevron-left'></span> Back to <a href='#{url_for(@previouspage)}'>#{@backlink}</a>".html_safe
      end
      format.html # show.html.erb
      format.json { render json: @page }
      format.json { render json: @definition }
      format.json { render json: @parentpages }
      format.json { render json: @subpages }
      format.json { render json: @relatedpages }
    end
  end

  def shownotes
    respond_to do |format|               
      format.js
    end        
  end 

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new
    @parentpage = params[:id]
    if @parentpage.present?    
    @backlink = Page.find(params[:id])
    @status  = params[:status] #checks whether the user is adding a related page or a subpage
    end

    respond_to do |format|
      if @parentpage.present? 
      flash.now[:notice] = "<span class='glyphicon icon-chevron-left'></span> Back to <a href='#{url_for(@parentpage)}'>#{@backlink.name}</a>".html_safe      
      end  
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])

    if @page.present? 
      flash.now[:notice] = "<span class='glyphicon icon-chevron-left'></span> Back to <a href='#{url_for(@page)}'>#{@page.name}</a>".html_safe      
    end  

  end

# POST /pages
  # POST /pages.json
  def create
    
    @page = Page.find_by_name(params[:page][:name])

    if (@page).nil? # if a page with this name doesn't exist, let's create it and set the page value
     @page = Page.new(params[:page])
    end

    if (params[:parent] && params[:status]).present?
    @status = params[:status] # checks whether we are adding a subpage or a related page
    @parentpage = Page.find(params[:parent]) # gets the value of the parent page from _form.html.erb
      if (@status == "subpage")   
        @page.parentpages << @parentpage #adds a habtm relationship page-parentpage
      end
      if (@status == "relatedpage")     
        @parentpage.relatedpages << @page #adds a habtm relationship page-relatedpage (using parentpage as page)     
      end
    end

    respond_to do |format|
      if @page.save
        @page.create_activity :create, owner: current_user #saves the user activity        
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def follow #adds user as a follower to a page/topic
      @user = current_user
      @page = Page.find(params[:id])
      @user.interests.create( :page_id => @page.id, :user_id => @user.id )
      
      respond_to do |format|
      if @user.interests.create
        @page.create_activity(:follow, owner: current_user)
        format.html { redirect_to @page, notice: 'This page has been added to your interests.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @page, notice: 'Something went wrong.' }
        format.json { head :no_content }
      end  
    end       
  end

  def unfollow #adds user as a follower to a page/topic
      @user = current_user
      @page = Page.find(params[:id])
      #@interest = @user.interests.find_by_sql ["select * from pages where id in (select page_id from interests where (user_id = ?))", @user] 
      @user.interests.destroy( :page_id => @page.id )

      
      respond_to do |format|
      if @user.interests.destroy
        format.html { redirect_to @page, notice: 'This page has been removed from your interests.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @page, notice: 'Something went wrong.' }
        format.json { head :no_content }
      end  
    end       
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      @page.create_activity :destroy, owner: current_user #saves the user activity              
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  def shownotes
  render :layout => false
end

private

  def require_login
    unless current_user
      redirect_to signin_path
    end
  end

end
