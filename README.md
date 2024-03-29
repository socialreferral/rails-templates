SocialReferral Rails Application Templates
==========================================
Rails 3.1 templates for setting up new Rails application.

Templates
---------
At the moment there is only one template: base.rb

This template sets up a base Rails 3.1 app with the following included:

- [Twitter Bootstrap using Sass](https://github.com/thomas-mcdonald/bootstrap-sass)
- Haml
- Foreman
- Unicorn
- simple_form
- inherited_resources

The following development tools are included:

- rails-dev-tweaks
- haml-rails
- Spork
- Guard

The new Rails application starts out with a HomeController with an index action that maps to root

You can start the Rails app with Foreman using 'bundle exec foreman start' or with Guard using 'bundle exec guard' 

Running with Guard will also run Spork and run tests as you change corresponding files

Usage
-----
Clone the repository and make use the templates like so when creating a new Rails project: 

```rails new depot -m path/to/rails-templates/base.rb```

License
-------
This code is released under the MIT license.

Authors
------
- [Mark Kremer](https://github.com/mkremer)
- [Andre Meij](https://github.com/ahmeij)

