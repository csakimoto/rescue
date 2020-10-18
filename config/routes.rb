require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  #message routes
  # get all message in database
  get 'message' => 'message#get_all'
  #send text message
  # post 'message' => 'message#send_message'
  post 'message' => 'message#create'
  #fields post call to execute send message batch
  post 'send_messages' => 'message#send_messages'

  #callback routs
  # Fields callbacks from provider
  post 'verify' => 'callback#verify'

  #route to look at sidekiq web stats
  mount Sidekiq::Web => '/sidekiq'

end
