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

  # create a students
  # def create
  #   @batch = Batch.find(params[:batch_id])
  #   @user = User.new(student_params)
  #   @user.batch = @batch
  #   if @user.save
  #     redirect_to batch_users_path(@batch)
  #   else
  #     render "batches/show"
  #   end
  # end


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
    # @user = User.find(params[:id])
    # @user.destroy
    # @batch = Batch.find(params[:batch_id])
    # redirect_to batch_users_path(@batch)
  end

  private

  def student_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
