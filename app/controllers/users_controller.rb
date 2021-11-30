class UsersController < ApplicationController
  def index
    redirect_to batches_path if current_user.admin == false

    @batch = Batch.find(params[:batch_id])
    @bookings = @batch.bookings.where(status: "Pending")
    @students = @batch.bookings.where(status: "Accepted").map do |booking|
      User.find(booking.user_id)
    end

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

  # def update
  #   @batch = Batch.find(params[:batch_id])
  #   @user = current_user
  #   if @user.update(student_params)
  #     redirect_to batch_users_path(@batch)
  #   else
  #     render 'edit'
  #   end
  # end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    # @batch = Batch.find(params[:batch_id])
    redirect_to batch_users_path
  end

  # private

  # def student_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :photo)
  # end

end
