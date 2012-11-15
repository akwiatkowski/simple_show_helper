simple_show_helper
=======

Why?
-----

It is intended to use with new Rails+Bootstrap apps to create as fast as possible 'show' pages.
You only have to add one line to view which will describe model instance + it references.

I use this tool here https://github.com/akwiatkowski/waypoint_manager/blob/master/app/views/areas/show.html.haml

How to?
-----

Add line in view

  = simple_model_details(User.first)

Keep in mind that it uses only locales in format for example: 'en.user.email'

Custom attributes:

  simple_model_details(User.first, attrs: ["email", "name"])

Add created_at, updated_at attributes:

  simple_model_details(User.first, timestamps: true)

Custom table class, for not Bootstrap users:

  simple_model_details(User.first, table_class: "table")

All options example:

 raw simple_model_details(resource, attrs: ["name"], timestamps: true, table_class: "table")


Spec, tests, ...
----------------

... :)


Contributing to simple_show_helper
-------------------------------

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=bobik314&url=https://github.com/akwiatkowski/simple_show_helper&title=simple_show_helper&language=en_GB&tags=github&category=software)

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


Copyright
---------

Copyright (c) 2012 Aleksander Kwiatkowski. See LICENSE.txt for
further details.

