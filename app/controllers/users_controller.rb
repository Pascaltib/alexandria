class UsersController < ApplicationController
  def index
    @batch = Batch.find(params[:batch_id])

    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        if booking.user_id == student.id
          @students << student
        end
      end
    end
  end

  def create
    @batch = Batch.find(params[:batch_id])
    @user = User.new(student_params)
    if @user.save
      redirect_to batch_users_path(@batch)
    else
      render 'edit'
    end
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

# to remove student

  def destroy
    @batch = Batch.find(params[:batch_id])
    @students.destroy
    # render ???????
  end

  private

  def student_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
