class BatchesController < ApplicationController
  def index
    @user = current_user
    @batches = Batch.where(user: current_user)
  end

  def show
    @batch = Batch.find(params[:id])
    @costs = @batch.costs
    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        if booking.user_id == student.id
          @students << student
        end
      end
    end
  end
end
