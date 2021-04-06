module Products
  class SellOutService
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        product = Product.find(@params[:id])
        warehouse = product.warehouse
        quantity = @params[:quantity].to_i

        if quantity.positive? && product.quantity >= quantity
          warehouse.update(balance: warehouse.balance + quantity * product.price)
          (product.quantity - quantity).zero? ? product.destroy : product.update(quantity: product.quantity - quantity)

          product = nil if product.destroyed?
          { params: @params, product: product, warehouse: warehouse, success: true, error: nil }
        else
          error = 'Invalid quantity parameter from params for the product'
          { params: @params, product: product, warehouse: warehouse, success: false, error: error }
        end
      end
    rescue ActiveRecord::RecordNotFound => e
      { params: @params, product: nil, warehouse: nil, success: false, error: e.message }
    end
  end
end
