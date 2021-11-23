class CostsController < ApplicationController
  def create
    @batch = Batch.find(params[:batch_id])
    @costs = @batch.costs

    @cost = Cost.new(cost_params)
    @cost.batch = @batch
    if @cost.save
      redirect_to batch_path(@batch)
    else
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
      render "batches/show"
    end
  end

  private

  def cost_params
    params.require(:cost).permit(:name, :amount)
  end
end
