require_dependency "concerto_emergency_broadcast/application_controller"

module ConcertoEmergencyBroadcast
  class EmsConfigController < ApplicationController

    def edit
      @ems_config = EmsConfig.first
      @feeds = Feed.all
    end

  end
end
