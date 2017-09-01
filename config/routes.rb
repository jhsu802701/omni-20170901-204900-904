# == Route Map
#
#                    Prefix Verb   URI Pattern                        Controller#Action
#         new_admin_session GET    /admins/sign_in(.:format)          admins/sessions#new
#             admin_session POST   /admins/sign_in(.:format)          admins/sessions#create
#     destroy_admin_session DELETE /admins/sign_out(.:format)         admins/sessions#destroy
#        new_admin_password GET    /admins/password/new(.:format)     admins/passwords#new
#       edit_admin_password GET    /admins/password/edit(.:format)    admins/passwords#edit
#            admin_password PATCH  /admins/password(.:format)         admins/passwords#update
#                           PUT    /admins/password(.:format)         admins/passwords#update
#                           POST   /admins/password(.:format)         admins/passwords#create
# cancel_admin_registration GET    /admins/cancel(.:format)           admins/registrations#cancel
#    new_admin_registration GET    /admins/sign_up(.:format)          admins/registrations#new
#   edit_admin_registration GET    /admins/edit(.:format)             admins/registrations#edit
#        admin_registration PATCH  /admins(.:format)                  admins/registrations#update
#                           PUT    /admins(.:format)                  admins/registrations#update
#                           DELETE /admins(.:format)                  admins/registrations#destroy
#                           POST   /admins(.:format)                  admins/registrations#create
#    new_admin_confirmation GET    /admins/confirmation/new(.:format) admins/confirmations#new
#        admin_confirmation GET    /admins/confirmation(.:format)     admins/confirmations#show
#                           POST   /admins/confirmation(.:format)     admins/confirmations#create
#          new_admin_unlock GET    /admins/unlock/new(.:format)       admins/unlocks#new
#              admin_unlock GET    /admins/unlock(.:format)           admins/unlocks#show
#                           POST   /admins/unlock(.:format)           admins/unlocks#create
#                    admins GET    /admins(.:format)                  admins#index
#                     admin GET    /admins/:id(.:format)              admins#show
#                           DELETE /admins/:id(.:format)              admins#destroy
#          new_user_session GET    /users/sign_in(.:format)           users/sessions#new
#              user_session POST   /users/sign_in(.:format)           users/sessions#create
#      destroy_user_session DELETE /users/sign_out(.:format)          users/sessions#destroy
#         new_user_password GET    /users/password/new(.:format)      users/passwords#new
#        edit_user_password GET    /users/password/edit(.:format)     users/passwords#edit
#             user_password PATCH  /users/password(.:format)          users/passwords#update
#                           PUT    /users/password(.:format)          users/passwords#update
#                           POST   /users/password(.:format)          users/passwords#create
#  cancel_user_registration GET    /users/cancel(.:format)            users/registrations#cancel
#     new_user_registration GET    /users/sign_up(.:format)           users/registrations#new
#    edit_user_registration GET    /users/edit(.:format)              users/registrations#edit
#         user_registration PATCH  /users(.:format)                   users/registrations#update
#                           PUT    /users(.:format)                   users/registrations#update
#                           DELETE /users(.:format)                   users/registrations#destroy
#                           POST   /users(.:format)                   users/registrations#create
#     new_user_confirmation GET    /users/confirmation/new(.:format)  users/confirmations#new
#         user_confirmation GET    /users/confirmation(.:format)      users/confirmations#show
#                           POST   /users/confirmation(.:format)      users/confirmations#create
#           new_user_unlock GET    /users/unlock/new(.:format)        users/unlocks#new
#               user_unlock GET    /users/unlock(.:format)            users/unlocks#show
#                           POST   /users/unlock(.:format)            users/unlocks#create
#                     users GET    /users(.:format)                   users#index
#                      user GET    /users/:id(.:format)               users#show
#                           DELETE /users/:id(.:format)               users#destroy
#              search_users POST   /users/search(.:format)            users#index
#                           GET    /users(.:format)                   users#index
#                           POST   /users(.:format)                   users#create
#                  new_user GET    /users/new(.:format)               users#new
#                 edit_user GET    /users/:id/edit(.:format)          users#edit
#                           GET    /users/:id(.:format)               users#show
#                           PATCH  /users/:id(.:format)               users#update
#                           PUT    /users/:id(.:format)               users#update
#                           DELETE /users/:id(.:format)               users#destroy
#                      root GET    /                                  static_pages#home
#                     about GET    /about(.:format)                   static_pages#about
#                   contact GET    /contact(.:format)                 static_pages#contact
# 

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # BEGIN: admin section
  devise_for :admins,
             controllers: { registrations: 'admins/registrations',
                            sessions: 'admins/sessions',
                            passwords: 'admins/passwords',
                            confirmations: 'admins/confirmations',
                            unlocks: 'admins/unlocks' }
  resources :admins, only: [:show, :index, :destroy]
  # END: admin section

  # BEGIN: user section
  devise_for :users,
             controllers: { registrations: 'users/registrations',
                            sessions: 'users/sessions',
                            passwords: 'users/passwords',
                            confirmations: 'users/confirmations',
                            unlocks: 'users/unlocks' }
  resources :users, only: [:show, :index, :destroy]
  resources :users do
    collection { post :search, to: 'users#index' }
  end
  # END: user section

  # BEGIN: static pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  # END: static pages
end
