module Products
  class TransferService
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        old_product = Product.find(@params[:id])
        new_product = nil
        new_warehouse = Warehouse.find(@params[:warehouse_id])
        quantity = @params[:quantity].to_i

        if old_product.warehouse == new_warehouse
          error = "warehouse_id from params is equal product's warehouse_id"
          { params: @params, old_product: old_product, new_product: nil, success: false, error: error }
        elsif quantity.positive? && old_product.quantity >= quantity
          ActiveRecord::Base.transaction do
            new_product_params = { name: old_product.name, price: old_product.price, warehouse: new_warehouse }
            new_product = Product.create_with(quantity: quantity).find_or_initialize_by(new_product_params)
            new_product.new_record? ? new_product.save : new_product.update(quantity: new_product.quantity + quantity)

            old_product.destroy if old_product.quantity == quantity
            old_product.update(quantity: old_product.quantity - quantity) unless old_product.destroyed?
          end

          old_product = nil if old_product.destroyed?
          { params: @params, old_product: old_product, new_product: new_product, success: true, error: nil }
        else
          error = 'Invalid quantity parameter from params for the product'
          { params: @params, old_product: old_product, new_product: new_product, success: false, error: error }
        end
      end
    rescue ActiveRecord::RecordNotFound => e
      { params: @params, old_product: nil, new_product: nil, success: false, error: e.message }
    end
  end
end
