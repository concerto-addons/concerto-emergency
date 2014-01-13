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

        # Controller hook for frontend/screens_controller#show
        add_controller_hook "Frontend::ScreensController", :setup, :before do
          # Check for active Emergency Alert Content
          emergency_feed = Feed.find_by_name("Emergency Alerts")
          
          # EmergencyAlert content is present, override the screen
          if not emergency_feed.nil? and not emergency_feed.submissions.where(:moderation_flag => true).empty?

            # Since an emergency alert was detected, make a copy of the 
            # requested screen and modify the setup to display the alerts
            emergency_screen = @screen.dup
            emergency_screen.id = @screen.id

            # Find our emergency template
            emergency_template = Template.find_by_name("Emergency Template")

            if emergency_template.nil? 
              # template not found, create a new one
              emergency_template = Template.create(:name => "Emergency Template", :author => "EmergencyPlugin", :is_hidden => true)

              # Find a graphics field
              graphics_field = Field.find_by_name("Graphics")

              # add a position to our new template
              emergency_template.positions << Position.create(:top => 0.0, :left => 0.0, :right => 1.0, :bottom => 1.0, 
                :field_id => graphics_field.id, :template_id => emergency_template.id, :style => 'background-color: #FF0000')

              # add field type to the template position 
              emergency_template.positions[0].field = graphics_field

              # Subscribe the Emergency Alerts Feed to the graphics field
              emergency_template.positions[0].field.subscriptions.clear
              emergency_template.positions[0].field.subscriptions << Subscription.new(:feed_id => emergency_feed.id,
                :field_id => graphics_field.id, :screen_id => @screen.id, :weight => 1, :id => Subscription.last.id + 1)
            end

            # Set our emergency template
            emergency_screen.template_id = emergency_template.id

            # Override the screen variable that the 
            # Frontend::ScreensController will respond with 
            @screen = emergency_screen

            # Skip screen.mark_updated call
            # (otherwise an error occurs with updating the screen column)
            # ((this is not a good idea ...))
            params[:preview] = 'true'
          end
        end

=begin
        # Controller hook for frontend/screens_controller#send_to_screen(screen)
        add_controller_hook "Frontend::ContentsController", :contents_setup, :before do

          # Check for the Emergency Alerts Feed
          emergency_feed = Feed.find_by_name("Emergency Alerts")

          if not emergency_feed.nil?
            # Only if Emergency Alert content is found, redirect to 
            # screen_controller#setup to swap templates and show alerts
            if not emergency_feed.submissions.where(:moderation_flag => true).empty?
              redirect_to setup_frontend_screen_path(@screen)
            end
          end

        end
=end


        # Controller hook and view hook for Screen Show page
        # the app crashed when I didn't have these added
        add_controller_hook "ScreensController", :show, :before do
        end
        add_view_hook "ScreensController", :screen_details, :text => ""
      end
    end

  end
end
