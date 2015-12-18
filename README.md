Concerto Emergency 
==================

This plugin provides [Concerto Digital Signage](https://github.com/concerto/concerto) with emergency alert capabilities. When content is submitted manually (or via an RSS feed) to a designated emergency alert feed, the plugin will change the effective template and display the emergency alert feed content. 

Instructions
------------
Clone the repository, navigate to the plugins page and add a new plugin using the filesystem path to concerto-emergency and then run ```bundle install```.  Or choose to add a new plugin within the concerto ui, choose Rubygems as the source and enter _concerto_emergency_ as the plugin name.

Plugin settings can be found under Admin > Settings > Emergency Alerts. The emergency template will replace the current template when any content is detected on the designated feed.  This plugin automatically creates a new feed called "Emergency Alerts" the first time it is loaded.
