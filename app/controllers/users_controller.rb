class UsersController < ApplicationController
  def index
    @batch = Batch.find(params[:batch_id])
    @booking = Booking.new
    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        if booking.user_id == student.id
          @students << student
        end
      end
    end

    @all_students = User.where(admin: false)
    # .map do |student|
    #   "#{student.first_name} + #{student.last_name}"
    # end
  end

  # to edit students profile
  def edit
    @batch = Batch.find(params[:batch_id])
    @user = User.find(params[:id])
  end

  def update
    @batch = Batch.find(params[:batch_id])
    @user = User.find(params[:id])
    if @user.update(student_params)
      redirect_to batch_users_path(@batch)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    # @batch = Batch.find(params[:batch_id])
    redirect_to batch_users_path
  end

  private

  def student_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
