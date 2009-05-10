ActionController::Routing::Routes.draw do |map|

  #root route
  map.root :controller => "clients"

  #backwards compatibility
  map.resources :clients
  map.resources :brands
  map.resources :products

  #nested routes
  map.resources :clients do |client|
    client.resources :brands do |brand|
      brand.resources :products
    end
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
