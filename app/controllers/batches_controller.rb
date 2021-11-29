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

    @batch = Batch.find(params[:id])
    @costs = @batch.costs
    @cost = Cost.new
    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        @students << student if booking.user_id == student.id
      end
    end

    @current_net_income = net_income_calc(@batch).round(2)
    @break_even = break_even_calc(@batch).round(2)

    # for the graph
    graph_quantity = (@break_even.round * 3) + 10
    @net_income_data_arr = net_income_data(graph_quantity, @batch)
    @variable_income_data_arr = variable_income_data(graph_quantity, @batch)
    @total_cost_data_arr = total_cost_data(graph_quantity, @batch)
    @variable_cost_data_arr = variable_cost_data(graph_quantity, @batch)
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
    params.require(:batch).permit(:name, :tuition_cost)
  end

  # For dashboard data infobox
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

  # For graph lines

  def net_income_data(quantity, batch)
    arr = []
    count = 0
    quantity.times do
      val = (count * (batch.tuition_cost - batch.costs.where(kind: "Variable").sum(&:amount))) - batch.costs.where(kind: "Fixed").sum(&:amount)
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

  def total_cost_data(quantity, batch)
    arr = []
    count = 0
    quantity.times do
      val = (count * batch.costs.where(kind: "Variable").sum(&:amount)) + batch.costs.where(kind: "Fixed").sum(&:amount)
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
