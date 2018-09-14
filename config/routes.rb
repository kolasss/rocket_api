# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :shops_categories, except: [:show]
      resources :shops do
        resources :products_categories, except: %i[index show] do
          resources :products, except: %i[index show]
        end
      end
      # namespace :admin do
      #   resources :shops
      # end
      # namespace :client do
      #   resources :shops
      # end
      # namespace :courier do
      #   resources :shops
      # end
      # namespace :shop_manager do
      #   resources :shops
      # end
      # namespace :supervisor do
      #   resources :shops
      # end
      namespace :users do
        post    :register,  to: 'registration#create'
        post    :login,     to: 'authentication#create'
        # delete  :logout,    to: 'authentication#destroy'
      end
      resources :users
    end
  end
end