class EventNamesController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :create]

  def index
    @event_names = EventName.list current_user
  end

  def create
    res = EventName.update_by_hash params[:event_names], current_user
    if res
      redirect_to event_names_path
    else
      head :ng
    end
  end
end
