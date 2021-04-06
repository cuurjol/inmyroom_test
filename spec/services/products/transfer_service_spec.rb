require 'rails_helper'

describe Products::TransferService do
  let(:product) { FactoryBot.create(:product, quantity: 5) }
  let(:warehouse) { FactoryBot.create(:warehouse) }

  subject(:service) { described_class.new(params) }

  describe '#call' do
    context 'when invalid id parameter for product' do
      let(:params) { { id: '-1', quantity: '5', warehouse_id: warehouse.id.to_s } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product]).to be_nil
        expect(result[:new_product]).to be_nil
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq("Couldn't find Product with 'id'=-1")
      end
    end

    context 'when invalid quantity parameter' do
      let(:params) { { id: product.id.to_s, quantity: '-5', warehouse_id: warehouse.id.to_s } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product]).to eq(product)
        expect(result[:new_product]).to be_nil
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Invalid quantity parameter from params for the product')
      end
    end

    context 'when invalid warehouse_id parameter for warehouse' do
      let(:params) { { id: product.id.to_s, quantity: '5', warehouse_id: '-1' } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product]).to be_nil
        expect(result[:new_product]).to be_nil
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq("Couldn't find Warehouse with 'id'=-1")
      end
    end

    context 'when warehouse_id parameter is equal warehouse_id for product' do
      let(:params) { { id: product.id.to_s, quantity: '5', warehouse_id: product.warehouse.id.to_s } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product]).to eq(product)
        expect(result[:new_product]).to be_nil
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq("warehouse_id from params is equal product's warehouse_id")
      end
    end

    context 'when transfer all products' do
      let(:params) { { id: product.id.to_s, quantity: '5', warehouse_id: warehouse.id.to_s } }

      it 'returns a hash with correct data and without error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product]).to be_nil
        expect(result[:new_product].quantity).to eq(5)
        expect(result[:success]).to be_truthy
        expect(result[:error]).to be_nil
      end
    end

    context 'when transfer 3 products' do
      let(:params) { { id: product.id.to_s, quantity: '3', warehouse_id: warehouse.id.to_s } }

      it 'returns a hash with correct data and without error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:old_product].quantity).to eq(2)
        expect(result[:new_product].quantity).to eq(3)
        expect(result[:success]).to be_truthy
        expect(result[:error]).to be_nil
      end
    end
  end
end
