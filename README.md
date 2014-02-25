Concerto Emergency 
==================

This plugin provides [Concerto Digital Signage](https://github.com/concerto/concerto) with emergency alert capabilities. When an emergency alert is submitted manually or an emergency alert is detected on an RSS feed, the plugin will change the effective template and display the alert. 

Instructions
------------
1. Clone the repository, navigate to the plugins page and add a new plugin using the filesystem path to concerto-emergency.

2. Run ```bundle install```

3. Plugin settings can be found under Admin > Settings > Emergency Alerts. The emergency template will replace the current template when emergency alerts are detected in the emergency feed. 
