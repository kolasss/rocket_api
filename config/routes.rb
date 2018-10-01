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
      resources :orders

      namespace :users do
        post    :login,     to: 'authentication#create'
        # delete  :logout,    to: 'authentication#destroy'
      end
      resources :users

      # namespace :admin do
      #   resources :shops
      # end
      namespace :client do
        post    :register,  to: 'registration#create'
        post    :login,     to: 'authentication#create'
        # delete  :logout,    to: 'authentication#destroy'
        # resources :shops
        resources :orders, except: %i[update destroy] do
          put :cancel
          put :make_request
        end
      end
      # namespace :courier do
      #   resources :shops
      # end
      namespace :shop_manager do
        resource :shop, except: %i[create destroy] do
          resources :products_categories, except: %i[index show] do
            resources :products, except: %i[index show]
          end
        end
      end
      namespace :supervisor do
        resources :orders, only: %i[index show] do
          post :assign_courier
        end
        resources :couriers, only: %i[index]
      end
    end
  end
end
