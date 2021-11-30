class BatchesController < ApplicationController
  def index
    @user = current_user
    @batches = @user.batches
    @batch = Batch.new
    @hidden = "hidden"

    if current_user.admin == false
      @batches = Batch.all
      @booking = Booking.new
    end
  end

  def show
    redirect_to batches_path if current_user.admin == false

    @hidden = "hidden"
    @hidden_cost = "hidden"
    @batch = Batch.find(params[:id])
    @costs = @batch.costs
    @cost = Cost.new
    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        @students << student if booking.user_id == student.id
      end
    end

    @batch_days = @batch.end_date - @batch.start_date
    @current_net_income = net_income_calc(@batch, @batch_days).round(2)
    @break_even = break_even_calc(@batch, @batch_days).round(2)

    # for the graph
    graph_quantity = (@break_even.round * 3) + 10
    @net_income_data_arr = net_income_data(graph_quantity, @batch, @batch_days)
    @variable_income_data_arr = variable_income_data(graph_quantity, @batch)
    @total_cost_data_arr = total_cost_data(graph_quantity, @batch, @batch_days)
    @variable_cost_data_arr = variable_cost_data(graph_quantity, @batch)

    @max_value = [@net_income_data_arr.max[1], @variable_income_data_arr.max[1], @total_cost_data_arr.max[1], @variable_cost_data_arr.max[1]].max.round + 10
    @min_value = [@net_income_data_arr.min[1], @variable_income_data_arr.min[1], @total_cost_data_arr.min[1], @variable_cost_data_arr.min[1]].min.round - 10
  end

  def create
    @user = current_user
    @batches = current_user.batches
    @batch = Batch.new(batch_params)
    @batch.user = @user
    if @batch.save
      redirect_to batches_path
    else
      @hidden = ""
      render :index
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:name, :tuition_cost, :start_date, :end_date)
  end

  # For dashboard data infobox
  def total_fixed_cost_calc(batch, days)
    return batch.costs.where(kind: "Fixed", recurring: "One Time").sum(&:amount) + (batch.costs.where(kind: "Fixed", recurring: "Daily").sum(&:amount) * days) + (batch.costs.where(kind: "Fixed", recurring: "Weekly").sum(&:amount) * (days/7.0)) + (batch.costs.where(kind: "Fixed", recurring: "Monthly").sum(&:amount) * (days/30.437)) + (batch.costs.where(kind: "Fixed", recurring: "Yearly").sum(&:amount) * (days/365.0))
  end

  def break_even_calc(batch, days)
    total_fixed_cost = total_fixed_cost_calc(batch, days)
    total_variable_cost = batch.costs.where(kind: "Variable").sum(&:amount)
    variable_revenue = batch.tuition_cost
    return total_fixed_cost / (variable_revenue - total_variable_cost)
  end

  def net_income_calc(batch, days)
    quantity = batch.bookings.count
    total_fixed_cost = total_fixed_cost_calc(batch, days)
    total_variable_cost = batch.costs.where(kind: "Variable").sum(&:amount)
    variable_revenue = batch.tuition_cost
    return (quantity * variable_revenue) - (quantity * total_variable_cost) - total_fixed_cost
  end

  # For graph lines

  def net_income_data(quantity, batch, days)
    arr = []
    count = 0
    quantity.times do
      val = (count * (batch.tuition_cost - batch.costs.where(kind: "Variable").sum(&:amount))) - total_fixed_cost_calc(batch, days).round(2)
      arr << [count, val]
      count += 1
    end
    arr
  end

  def variable_income_data(quantity, batch)
    arr = []
    count = 0
    quantity.times do
      val = count * batch.tuition_cost
      arr << [count, val]
      count += 1
    end
    arr
  end

  def total_cost_data(quantity, batch, days)
    arr = []
    count = 0
    quantity.times do
      val = (count * batch.costs.where(kind: "Variable").sum(&:amount)) + total_fixed_cost_calc(batch, days).round(2)
      arr << [count, val]
      count += 1
    end
    arr
  end

  def variable_cost_data(quantity, batch)
    arr = []
    count = 0
    quantity.times do
      val = count * batch.costs.where(kind: "Variable").sum(&:amount)
      arr << [count, val]
      count += 1
    end
    arr
  end
end
