class ProductsController < ApplicationController
  def transfer
    result = Products::TransferService.new(product_params.merge(id: params[:id])).call
    render(json: result, status: result[:success] ? :ok : :unprocessable_entity)
  end

  def sell_out
    result = Products::SellOutService.new(product_params.merge(id: params[:id])).call
    render(json: result, status: result[:success] ? :ok : :unprocessable_entity)
  end

  private

  def product_params
    params.require(:product).permit(:name, :quantity, :price, :warehouse_id)
  end
end
