Booking.com™ Job Monitor application
========================

The purpose of this application is to monitor the job vacancies advertised in the official Booking.com™ website.

Booking.com™ is an international company which grows very fast and it posts up and down jobs pretty fast. I wanted to be
able to monitor the jobs for my personal job research and came up with this application.

The application also demonstrates the use of some interesting gems:

* Resque (Background jobs)
* Mechanize/Nokogiri (web page parser)
* MongoDB (noSQL DB)
* lazy_high_charts (based on HighChart JS)
* foreman

####How to install:

You need first to install `MongoDB` and `REDIS` (Resque needs that).

You just `git clone` the project and `bundle install`

You need to edit the `Procfile` on the root of the project to reflect your local settings.

You then `foreman start` and direct your browser to `http://localhost:5000`

####How to use:

You just press `Update` and wait until the DB is populated. You can check the progress by pressing the `Resque` link.

####TO DOs:
* Seed the development database to reflect jobs opened and closed at an earlier time. Mine starts from September, 12th.
* Add more Statistics
* Add Google Maps and visualize the jobs on the map.

###Disclaimer:
*	This application is **NOT** endorsed, **NOT** approved and **NOT** affiliated by or to Booking.com™ by any way.

	It was just a way to monitor the job openings for personal use.

*	_The only way to accurately monitor the job openings and their description is to visit the official Booking.com(TM) website._
*	The monitoring of the positions is starting by the moment your firstly populate the Database. This means that all the jobs are considered to be open by that exact moment and **NOT** the time that they were really advertised.

_Booking.com B.V. is part of Priceline.com (Nasdaq: PCLN) and it owns and operates Booking.com™_