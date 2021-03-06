Rails.application.routes.draw do
  root to: 'home#index'

  get '/sign_in', to: 'authentication#sign_in'
  post '/sign_in', to: 'authentication#login'

  get '/signed_out', to: 'authentication#signed_out'
  get '/change_password', to: 'authentication#change_password'
  get '/forgot_password', to: 'authentication#forgot_password'
  
  get '/new_user', to: 'authentication#new_user'
  put '/new_user', to: 'authentication#register'
  
  get '/account_settings', to: 'authentication#account_settings'
  put '/account_settings', to: 'authentication#set_account_info'

  get '/password_sent', to: 'authentication#password_sent'

  get '/forgot_password', to: 'authentication#forgot_password'
  put '/forgot_password', to: 'authentication#send_password_reset_instructions'

  get '/password_reset', to: 'authentication#password_reset'
  put '/password_reset', to: 'authentication#new_password'

  get '/admin/users', to: 'admin#users'
  delete '/admin/:id', to: 'admin#delete_user', as: 'user'

  get '/test', to: 'home#test'
  post '/test2', to: 'home#test2'

  resources :spells
  resources :characters do 
    member do
      get '/edit_spells', to: 'characters#edit_spells'
      put '/edit_spells', to: 'characters#update_spells'
    end
  end
  
  # get '/edit_spells', to: 'character#edit_spells'
  # put '/edit_spells', to: 'character#update_spells'
end
