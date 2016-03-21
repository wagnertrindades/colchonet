class RoomsController < ApplicationController
  before_action :set_current_user_rooms, only: [:edit, :update, :destroy]
  before_filter :require_authentication,
    :only => [:new, :edit, :create, :update, :destroy]

  def index
    @rooms = Room.most_recent
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to @room, :notice => t('flash.notice.room_created')
    else
      render action: "new"
    end

  end

  def update
    if @room.update_attributes(room_params)
      redirect_to @room, :notice => t('flash.notice.room_updated')
    else
      render :action => "edit"
    end
  end

  def destroy
    @room.destroy

    redirect_to rooms_url
  end

  private

  def set_current_user_rooms
    @room = current_user.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:title, :location, :description)
  end
end
