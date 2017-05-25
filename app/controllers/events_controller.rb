class EventsController < ApplicationController


  
  def index
    @now = Time.now.strftime("%Y-%m-%d")
    @events = Event.joins(:user).all
    puts @events.all
    @mystate = User.select(:state).find(session[:user_id])
    @attendees = Attendee.all
  end

  def show
    @event = Event.joins(:user).find(params[:id])
    @attendees = Attendee.joins(:user).where('event_id=?',params[:id])
    @messages = Message.joins(:event).where('event_id=?',params[:id])
  end


  def create
    @event = Event.new(event_params)


    if @event.save
      redirect_to '/'
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    end
  end

  def message
    @message = Message.new(context:params[:context],user:params[:name],event_id: params[:event_id])

    if @message.save
      redirect_to "/events/#{params[:event_id]}"
    else
      flash[:errors]=@message.errors.full_messages
      redirect_to :back
    end

  end

  def join
    @attend = Attendee.new(user_id:session[:user_id], event_id: params[:id])

    if @attend.save
      redirect_to '/'
    else
      flash[:errors] = @attend.errors.full_messages
      redirect_to :back
    end
  end

  def cancel
    @attendee = Attendee.find_by('event_id =?', params[:attendee_id])
    if @attendee.destroy
      redirect_to '/'
    else
      flash[:errors] = @attendee.errors.full_messages
      redirect_to :back
    end
  end

  def delete
    @event = Event.find(params[:event_id])
    if @event.destroy
      redirect_to '/'
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to :back
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @now = Time.now.strftime("%Y-%m-%d")

  end

  def update
    @event = Event.find(params[:event_id])
    if @event.update event_params
      redirect_to '/'
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to :back
    end
  end


private
  def event_params
    params.require(:event).permit(:name,:location,:state,:date,:user_id)

  end

  def attendee_params
    params.require(:attendee).permit(:user_id,:event_id)
  end

end
