class NotesController < ApplicationController
  include ActionView::Helpers::TextHelper

before_filter :authorize, :except => [:show, :new, :create, :upvote]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])
    @title = @note.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new
    @note = Note.new
    @page = Page.find(params[:id]) # gets the value of the parent page

    respond_to do |format|
      flash.now[:notice] = "<span class='glyphicon icon-chevron-left'></span> Back to <a href='#{url_for(@page)}'>#{@page.name}</a>".html_safe      
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.json
  def create
    #@note = Note.new(params[:note])

    if params[:parent].present?
    @page = Page.find(params[:parent]) # gets the value of the parent page from _form.html.erb
        @note = current_user.notes.build(:title => params[:title], :content => params[:content])
        @note.page = @page
        @note.save        
    end

    respond_to do |format|
      if @note.save
        @note.create_activity :create, owner: current_user #saves the user activity        
        format.html { redirect_to @page, notice: 'Note was successfully created.' }
        format.json { render json: @page, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def upvote
    @note = Note.find params[:id]
    current_user.up_vote(@note)
    @note.create_activity(:upvoted, owner: current_user)
    flash[:message] = 'Thanks for voting!'
    redirect_to note_path(@note)
  rescue MakeVoteable::Exceptions::AlreadyVotedError
    flash[:error] = 'Already voted!'
    redirect_to note_path(@note)
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      @note.create_activity :destroy, owner: current_user #saves the user activity              
      format.html { redirect_to @note.page }
      format.json { head :no_content }
    end
  end

private

  def authorize
    @note = Note.find(params[:id])
      
    if(@note.user != current_user)
      render text:"NOT authorized"
    end
  end

end