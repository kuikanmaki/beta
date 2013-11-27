class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    if @book.present?
      @pages = @book.pages
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
      format.json { render json: @pages }      
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
          
      @book = Book.new(params[:book])
      @page = Page.find(params[:page_id]) # gets the value of the parent page
      
    if (params[:book] && params[:page_id]).present?
        @book.pages << @page #adds a habtm relationship pages-books
    end

      respond_to do |format|
        if @book.save
          @book.create_activity :create, owner: current_user #saves the user activity
          format.html { redirect_to @book, notice: 'Book was successfully created.' }
          format.json { render json: @book, status: :created, location: @book }
        else
          format.html { render action: "new" }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      @book.create_activity :destroy, owner: current_user #saves the user activity
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end
