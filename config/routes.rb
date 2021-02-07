Rails.application.routes.draw do
  post '/products/:id/transfer', to: 'products#transfer', as: 'transfer_product'
  post '/products/:id/sell_out', to: 'products#sell_out', as: 'sell_out_product'
end
