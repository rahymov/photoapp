Rails.application.routes.draw do
  
  resources :images
  root 'welcome#index'  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  
end
