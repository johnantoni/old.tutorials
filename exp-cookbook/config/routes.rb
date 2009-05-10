ActionController::Routing::Routes.draw do |map|

  map.root :controller => "categories"

  map.resources :categories
  map.resources :recipes

  map.resources :categories do |category|
    category.resources :recipes
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
