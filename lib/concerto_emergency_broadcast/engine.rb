module ConcertoEmergencyBroadcast
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergencyBroadcast

    engine_name 'ems'

    initializer "register content type" do |app|
      app.config.content_types << EmergencyAlert
      app.config.content_types << EmergencyRss
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Controller hook and view hook for Screen Show page
        # the app crashed when I didn't have these added
        add_controller_hook "ScreensController", :show, :before do
        end
        add_view_hook "ScreensController", :screen_details, :text => ""


        # Controller hook for frontend/screens_controller#show
        add_controller_hook "Frontend::ScreensController", :setup, :before do
          # Check for active EmergencyAlert Content
          emergency_feed = Feed.find_by_name("Emergency Alerts")
          
          # EmergencyAlert content is present, override the screen
          if not emergency_feed.submissions.where(:moderation_flag => true).empty?

            # Since an emergency alert was detected, make a copy of the 
            # requested screen and modify the setup to display the alerts
            emergency_screen = @screen.dup
            emergency_screen.id = @screen.id

            # Find and Add a graphics field
            graphics_field = Field.find_by_name("Graphics")
            emergency_screen.fields << graphics_field

            # Find and set our emergency template
            emergency_template = Template.find_by_name("Emergency Template")
            if emergency_template.nil? 
              emergency_template = Template.create(:name => "Emergency Template", :author => "EmergencyPlugin", :is_hidden => true)
              emergency_template.positions << Position.create(:top => 0.0, :left => 0.0, :right => 1.0, :bottom => 1.0, 
                :field_id => graphics_field.id, :template_id => emergency_template.id, :style => 'background-color: #FF0000')
            end

            emergency_screen.template_id = emergency_template.id

            # Subscribe the Emergency Alerts Feed to the graphics field
            emergency_screen.fields[0].subscriptions.clear
            emergency_screen.fields[0].subscriptions << Subscription.new(:feed_id => emergency_feed.id,
              :field_id => graphics_field.id, :screen_id => @screen.id, :weight => 1, :id => Subscription.last.id + 1)

            # Override the screen variable that the 
            # Frontend::ScreensController will respond with 
            @screen = emergency_screen
          end

        end

      end
    end

  end
end
