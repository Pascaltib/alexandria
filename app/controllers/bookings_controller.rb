class BookingsController < ApplicationController
  def create
    @batch = Batch.find(params[:booking][:batch_id])
    @user = current_user
    @booking = Booking.new(batch: @batch, user: @user)
    if @booking.save
      redirect_to batches_path
    else
      # raise
      @batches = Batch.all
      render "batches/index"
    end


    # old booking code
    # @batch = Batch.find(params[:batch_id])
    # unless params[:booking][:user_id] == ''
    #   @user = User.find(params[:booking][:user_id])
    # end
    # @booking = Booking.new(batch: @batch, user: @user)
    # @students = []
    # User.where(admin: false).each do |student|
    #   @batch.bookings.each do |booking|
    #     if booking.user_id == student.id
    #       @students << student
    #     end
    #   end
    # end
    # if @booking.save
    #   redirect_to batch_users_path
    # else
    #   # raise
    #   @all_students = User.where(admin: false)
    #   render "users/index"
    # end
  end

  def accept
    booking = Booking.find(params[:id])
    booking.status = "Accepted"
    booking.save!
    # for the notification
    flash[:alert] = "An email was sent to #{User.find(booking.user_id).first_name} #{User.find(booking.user_id).last_name}"
    redirect_to batch_users_path(Batch.find(booking.batch_id))
  end

  def pending
    booking = Booking.find(params[:id])
    booking.status = "Pending"
    booking.save!
    redirect_to batch_users_path(Batch.find(booking.batch_id))
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
