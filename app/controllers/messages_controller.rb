  class MessagesController < ApplicationController

  # have to add the before_filter for users here
  before_filter :get_mailbox, :get_box, :get_user
  def index
    redirect_to conversations_path(:box => @box)
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    if @message = Message.find_by_id(params[:id]) and @conversation = @message.conversation
      if @conversation.is_participant?(@user)
        redirect_to conversation_path(@conversation, :box => @box, :anchor => "message_" + @message.id.to_s)
      return
      end
    end
    redirect_to conversations_path(:box => @box)
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
 @recipient = User.find_by_id(params[:id])
  end

  # GET /messages/1/edit
  def edit

  end

  # POST /messages
  # POST /messages.xml
  def create

    @recipient = User.find(params[:recipient])
    @receipt = @user.send_message(@recipient, params[:body], params[:subject], nil, nil, nil)
    if (@receipt.errors.blank?)
      @receipt.save
      @conversation = @receipt.conversation
      redirect_to @conversation, :flash => { :success => "Message sent." }
    else
      render :action => :new
    end 
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update

  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy

  end

  private

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  def get_user
    @user = current_user
  end

  def get_box
    if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
      @box = "inbox"
    return
    end
    @box = params[:box]
  end

end