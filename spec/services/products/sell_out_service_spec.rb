require 'rails_helper'

describe Products::SellOutService do
  describe '#call' do
    let(:product) { FactoryBot.create(:product, quantity: 5) }

    subject(:service) { described_class.new(params) }

    context 'when invalid id parameter for product' do
      let(:params) { { id: '-1', quantity: '5' } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:product]).to be_nil
        expect(result[:warehouse]).to be_nil
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq("Couldn't find Product with 'id'=-1")
      end
    end

    context 'when invalid quantity parameter' do
      let(:params) { { id: product.id.to_s, quantity: '-5' } }

      it 'returns a hash with error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:product]).to eq(product)
        expect(result[:warehouse].balance).to eq(0)
        expect(result[:success]).to be_falsey
        expect(result[:error]).to eq('Invalid quantity parameter from params for the product')
      end
    end

    context 'when sell out all products' do
      let(:params) { { id: product.id.to_s, quantity: '5' } }

      it 'returns a hash with correct data and without error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:product]).to be_nil
        expect(result[:warehouse].balance).to eq(product.price * 5)
        expect(result[:success]).to be_truthy
        expect(result[:error]).to be_nil
      end
    end

    context 'when sell out 3 products' do
      let(:params) { { id: product.id.to_s, quantity: '3' } }

      it 'returns a hash with correct data and without error message' do
        result = service.call
        expect(result[:params]).to eq(params)
        expect(result[:product].quantity).to eq(2)
        expect(result[:warehouse].balance).to eq(product.price * 3)
        expect(result[:success]).to be_truthy
        expect(result[:error]).to be_nil
      end
    end
  end
end
