Rails.application.routes.draw do

	root 'welcome#index'

	get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'

	resources :categories
	resources :consolidates
	resources :departments
	resources :designations
	resources :groups
	resources :officers
	resources :products
	resources :requests
	resources :request_lines
	resources :types
	resources :units
	resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
