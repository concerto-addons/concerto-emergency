Rails.application.routes.draw do

  mount ConcertoEmergencyBroadcast::Engine => "/concerto_emergency_broadcast"
end
