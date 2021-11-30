class CostsController < ApplicationController
  def create
    @batch = Batch.find(params[:batch_id])
    @costs = @batch.costs

    @cost = Cost.new(cost_params)
    @cost.batch = @batch
    if @cost.save
      redirect_to batch_path(@batch)
    else
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

      @hidden = "hidden"
      @hidden_cost = ""
      render "batches/show"
    end
  end

  def destroy
    @cost = Cost.find(params[:id])
    @cost.destroy
    @batch = Batch.find(params[:batch_id])
    redirect_to batch_path(@batch)
  end

  def update
    @batch = Batch.find(params[:batch_id])
    @cost = Cost.find(params[:id])
    @costs = @batch.costs
    if @cost.update(cost_params)
      redirect_to batch_path(@batch)
    else
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

      @hidden = ""
      @hidden_cost = "hidden"
      render "batches/show"
    end
  end

  private

  def cost_params
    params.require(:cost).permit(:name, :amount, :kind, :recurring)
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
