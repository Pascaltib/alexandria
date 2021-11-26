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

    # Do not delete used for adding new student to batch
    @all_students = User.where(admin: false)

    # search form
    # get the user(student) that was added to the batch through bookings
    # display the one that is searched for
    # if there is no match then render to all the (user) that is added to the batch

    if params[:query].present?
      @student_search = []
      @students.each do |individual|
        if individual.first_name.downcase == params[:query].downcase || individual.last_name.downcase == params[:query].downcase
          @student_search << individual
        end
      end
      @students = @student_search
      # @student = User.joins(:batch).where(sql_query, query: "%#{params[:query]}%")
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
