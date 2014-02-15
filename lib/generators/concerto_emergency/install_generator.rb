require 'rails/generators'

module ConcertoEmergency
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../', __FILE__)

    desc 'Copy the Places JavaScript to the frontend and register it.'
 
    def install
      copy_js
      register
      recompile
    end

    private
      def copy_js
        copy_file 'public/frontend_js/contents/emergency_alert.js', 'public/frontend_js/contents/emergency_alert.js'
      end

      def register
        append_file 'public/frontend_js/content_types.js', "goog.require('concerto.frontend.Content.EmergencyAlert');\n"
      end

      def recompile
        inside 'public/frontend_js' do 
          run('/bin/bash compile.sh', {:verbose => true})
        end
      end
  end
end
