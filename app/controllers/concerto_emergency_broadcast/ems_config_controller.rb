require_dependency "concerto_emergency_broadcast/application_controller"

module ConcertoEmergencyBroadcast
  class EmsConfigController < ApplicationController

    def index
      @ems_config = EmsConfig.first
    end

    def edit
      @ems_config = EmsConfig.first
    end

    def update
      @ems_config = EmsConfig.first
      #render :text => params.inspect
      @ems_config.update_attributes(ems_config_params)
      redirect_to ems_config_index_path 
    end

    private
      def ems_config_params
        params.require(:ems_config).permit(:template_id, :feed_id)
      end

  end
end
