class BatchesController < ApplicationController
  def index
    @user = current_user
    @batches = @user.batches
    @batch = Batch.new
  end

  def show
    @batch = Batch.find(params[:id])
    @costs = @batch.costs
    @cost = Cost.new
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
    @user = current_user
    @batches = current_user.batches
    @batch = Batch.new(batch_params)
    @batch.user = @user
    if @batch.save
      redirect_to batches_path
    else
      render :index
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:name)
  end
end
