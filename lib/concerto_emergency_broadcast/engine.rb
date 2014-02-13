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

        add_route("ems", ConcertoEmergencyBroadcast::Engine)

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Effective template hook 
        add_controller_hook "Screen", :frontend_display, :after do

          emergency_feed = Feed.find(EmsConfig.first.feed_id)

          # Check for emergency content 
          if not emergency_feed.nil? and not emergency_feed.submissions.approved.active.empty?
            # swap template to emergency template if emergency content is present
            self.template = Template.find(EmsConfig.first.template_id)
          end

        end

        # Controller hook for frontend/contents_controller
        add_controller_hook "Frontend::ContentsController", :index, :after do

          emergency_feed = Feed.find(EmsConfig.first.feed_id)
          
          if not emergency_feed.nil?
            emergency_submissions = emergency_feed.submissions.approved.active
            emergency_contents = Array.new()
            emergency_submissions.each { |submission| emergency_contents << Content.find(submission.content_id) }
        
            if not emergency_contents.empty?
              # Content supplied to screen is replaced with emergency contents
              @content = emergency_contents
            end
          end

        end

        # Controller hook and view hook for Screen Show page
        # the app crashed when I didn't have these added
        add_controller_hook "ScreensController", :show, :before do
          if EmsConfig.first.nil?
            EmsConfig.create(:template_id => 1, :feed_id => 1)
          end
          @ems_config = EmsConfig.first
        end

        # Screen#Show view hook for ems configuration
        add_view_hook "ScreensController", :screen_details, :partial => "concerto_emergency_broadcast/ems_config/screen_details"
      
      end
    end

  end
end