module Products
  class SellOutService
    def initialize(params)
      @params = params
    end

    def call
      product = Product.find(@params[:id])
      warehouse = product.warehouse
      quantity = @params[:quantity].to_i

      if quantity.positive? && product.quantity >= quantity
        ActiveRecord::Base.transaction do
          warehouse.update(balance: warehouse.balance + quantity * product.price)
          (product.quantity - quantity).zero? ? product.destroy : product.update(quantity: product.quantity - quantity)
        end

        product = nil if product.destroyed?
        { params: @params, product: product, warehouse: warehouse, success: true, error: nil }
      else
        error = 'Invalid quantity parameter from params for the product'
        { params: @params, product: product, warehouse: warehouse, success: false, error: error }
      end
    rescue ActiveRecord::RecordNotFound => e
      { params: @params, product: nil, warehouse: nil, success: false, error: e.message }
    end
  end
end
