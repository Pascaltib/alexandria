class BookingsController < ApplicationController
  def create
    @batch = Batch.find(params[:batch_id])
    unless params[:booking][:user_id] == ''
      @user = User.find(params[:booking][:user_id])
    end
    @booking = Booking.new(batch: @batch, user: @user)
    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        if booking.user_id == student.id
          @students << student
        end
      end
    end
    if @booking.save
      redirect_to batch_users_path
    else
      # raise
      @all_students = User.where(admin: false)
      render "users/index"
    end
  end

  # to remove student
  def destroy
    @batch = Batch.find(params[:batch_id])
    # @user = User.find(params[:booking][:user_id])
    @booking = Booking.where(user_id: params[:id], batch_id: params[:batch_id])[0]
    @booking.destroy
    redirect_to batch_users_path(@batch)
  end

  private
  def booking_params
    params.require(:booking).permit(:user_id, :batch_id)
  end
end
