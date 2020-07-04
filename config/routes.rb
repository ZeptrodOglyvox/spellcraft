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

  get '/delete/:username', to: 'authentication#destroy_user'
end
