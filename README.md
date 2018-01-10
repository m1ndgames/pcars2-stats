# pcars2-stats
Project Cars 2 stats generation Script

This script creates a Table out of Project Cars 2 dedicated server lua stats plugin.

It expects to find 'sms_stats_data.json' in the same path.

The 'vehicle.json' was extracted from the server api. It might need to be updated when new cars/liveries are added to the game.


It will spit out HTML so you can either run it as a CGI, or pipe into some html file.


It uses http://listjs.com/ for table sorting/filtering.


Demo: http://stats.m1nd.io/
