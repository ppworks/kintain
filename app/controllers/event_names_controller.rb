class EventNamesController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :create]

  def index
    @event_names = EventName.list current_user
  end

  def create
    @event_names = EventName.update_by_hash params[:event_names], current_user
    errors = @event_names.select{|event_name|event_name.errors.present?}
    if errors.present?
      render :index
    else
      redirect_to event_names_path, :notice => I18n.t('event_names.index.created')
    end
  end
end
