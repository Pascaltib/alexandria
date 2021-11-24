class BookingsController < ApplicationController
  def create
    @user = current_user
    @batches = current_user.batches
    @booking = Booking.new(booking_params)
    @batch.user = @user
    @booking.save
    # if @booking.save
    #   redirect_to batch_bookings_path
    # else
    #   render :????
    # end
  end

  private
  def booking_params
    params.require(:booking).permit(:user_id, :batch_id)
  end
end
