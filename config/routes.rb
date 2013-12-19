ConcertoEmergencyBroadcast::Engine.routes.draw do

  root :to => proc { |env| [200, {}, ["Welcome to the Emergency Broadcast Plugin!"]]}

  resources :alerts

end
