Rails.application.routes.draw do

	root 'welcome#index'

	get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'

	resources :users
	resources :types
	resources :products
	resources :departments
	resources :designations
	resources :groups
	resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
