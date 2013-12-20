require_dependency "concerto_emergency_broadcast/application_controller"

module ConcertoEmergencyBroadcast
  class AlertsController < ApplicationController

    # GET /alerts
    def index
      @alerts = Alert.all
    end

    # GET /alerts/1
    def show
      @alert = Alert.find(params[:id])
    end

    # GET /alerts/new
    def new
      @alert = Alert.new
    end

    # GET /alerts/1/edit
    def edit
      @alert = Alert.find(params[:id])
    end

    # POST /alerts
    def create
      @alert = Alert.new(alert_params)

      if @alert.save
        redirect_to @alert, notice: 'Alert was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /alerts/1
    def update
      @alert = Alert.find(params[:id])
      if @alert.update_attributes(alert_params)
        redirect_to @alert, notice: 'Alert was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /alerts/1
    def destroy
      @alert = Alert.find(params[:id])
      @alert.destroy
      redirect_to alerts_url, notice: 'Alert was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_alert
        @alert = Alert.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def alert_params
        params.require(:alert).permit(:body)
      end
  end
end
