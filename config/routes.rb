ConcertoEmergencyBroadcast::Engine.routes.draw do

  root :to => 'alerts#index'

  resources :alerts

end
