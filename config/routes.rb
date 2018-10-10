# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :users do
        post :login, to: 'authentication#create'
        # delete  :logout,    to: 'authentication#destroy'
      end

      namespace :admin do
        resources :districts, except: [:show]
        resources :shops_categories, except: [:show]
        resources :shops do
          resources :products_categories, except: %i[index show] do
            resources :products, except: %i[index show]
          end
        end
        resources :orders
        resources :users
      end

      namespace :client do
        post :register, to: 'registration#create'
        post :login,    to: 'authentication#create'
        # delete  :logout,    to: 'authentication#destroy'
        resources :districts, only: %i[index]
        resources :shops_categories, only: %i[index]
        resources :shops, only: %i[index show]
        resources :orders, except: %i[update destroy] do
          put :cancel
          put :make_request
        end
      end

      namespace :courier do
        resource :ready, only: %i[create destroy], controller: :ready
        resource :active_order, only: [:show] do
          put :accept
          put :decline
          put :arrive
          put :pick_up
          put :deliver
        end
      end

      namespace :shop_manager do
        resource :shop, except: %i[create destroy] do
          resources :products_categories, except: %i[index show] do
            resources :products, except: %i[index show]
          end
        end
        resources :orders, only: %i[index] do
          put :accept
          put :cancel
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
