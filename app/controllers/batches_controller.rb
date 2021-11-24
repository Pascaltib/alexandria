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
        @students << student if booking.user_id == student.id
      end
    end
    @break_even = break_even_calc(@batch).round(2)
    @current_net_income = net_income_calc(@batch).round(2)
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
    params.require(:batch).permit(:name, :tuition_cost)
  end

  def break_even_calc(batch)
    total_fixed_cost = batch.costs.where(kind: "Fixed").sum(&:amount)
    total_variable_cost = batch.costs.where(kind: "Variable").sum(&:amount)
    variable_revenue = batch.tuition_cost
    return total_fixed_cost / (variable_revenue - total_variable_cost)
  end

  def net_income_calc(batch)
    quantity = batch.bookings.count
    total_fixed_cost = batch.costs.where(kind: "Fixed").sum(&:amount)
    total_variable_cost = batch.costs.where(kind: "Variable").sum(&:amount)
    variable_revenue = batch.tuition_cost
    return (quantity * variable_revenue) - (quantity * total_variable_cost) - total_fixed_cost
  end
end
