class RoomsController < ApplicationController

  def index
    @rooms = Room.where(:public => true).order("created_at DESC")
    @new_room = Room.new
  end

  def create
    config_opentok
    session = @opentok.create_session request.remote_addr
    params[:room][:sessionId] = session.session_id

    @new_room = Room.new(params[:room])

    respond_to do |format|
      if @new_room.save
        format.html { redirect_to("/party/"+@new_room.id.to_s) }
      else
        format.html { render :controller => 'rooms', 
               :action => "index" }
      end
    end
  end

  def party
    @room = Room.find(params[:id])
    
    config_opentok

    @tok_token = @opentok.generate_token :session_id => 
          @room.sessionId
  end

  private

      API_KEY = "44292782"     #{}"44056962"
      API_SECRET = "73f95090d7e500c858218e6deb67b361de396923"  #{}"935204fe269f147db7e28c3e5490260a069970d3"

  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTokSDK.new API_KEY, API_SECRET, :api_url => 'https://api.opentok.com/hl'
    end
  end
end