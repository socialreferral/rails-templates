# Prepend base directory to search paths for the generators (so our templates can override base Rails templates)
source_paths.unshift("#{File.dirname(__FILE__)}/base")

# Enable Unicorn in the Gemfile
gsub_file 'Gemfile', /^# (gem 'unicorn.*)$/, '\1'

# Create a development group in the Gemfile and add gems to it
insert_into_file 'Gemfile', before: "group :test do\n" do
<<-GEMFILE
group :development do
  # Tweaks the code reloading behavior in development mode
  gem 'rails-dev-tweaks'
  # Adds template generators for Haml
  gem 'haml-rails'
end

GEMFILE
end

# Add default set of gems to :development and :test groups
insert_into_file 'Gemfile', before: "group :test do\n" do
<<-GEMFILE
group :development, :test do
  # Enable the use of Guard
  gem 'guard'
  gem 'rb-inotify' if RbConfig::CONFIG['target_os'] == 'linux'
  gem 'libnotify' if RbConfig::CONFIG['target_os'] == 'linux'

  # Add Guard to run unit tests
  gem 'guard-test'

  # Add Guard to run arbitrary processes and commands (as specified in the Guardfile)
  gem 'guard-process'

  # Enable the use of Spork with Guard
  gem 'spork', '~> 0.9.0rc'
  gem 'spork-testunit', :git => "https://github.com/socialreferral/spork-testunit.git", :branch => "feature/drbport"
  gem 'guard-spork'
end

GEMFILE
end

# Add default set of gems to :test group
insert_into_file 'Gemfile', after: "group :test do\n" do
<<-GEMFILE
  # Profiling gem
  gem 'ruby-prof'

  # Enables the use of FactoryGirl for testing
  gem 'factory_girl_rails'

  # Enable the use of Mocha for mocking and stubbing in tests
  gem 'mocha', :require => false
GEMFILE
end

# Add default Gems for the Rails application itself
append_to_file 'Gemfile', <<-GEMFILE

gem 'haml'
gem 'therubyracer'
gem 'simple_form'
gem 'inherited_resources'
GEMFILE

# Delete the default README
remove_file 'README'

# Setup the Twitter Bootstrap (using the Sass version)
insert_into_file 'Gemfile', after: "group :assets do\n" do
  "  gem 'bootstrap-sass'\n"
end

file 'app/assets/stylesheets/default.css.scss', '@import "bootstrap";'
append_file 'app/assets/javascripts/application.js', <<-BOOTSTRAP

// Loads all Bootstrap javascripts
//= require bootstrap
BOOTSTRAP

# Remove require tree from application.js ... you now need to add your own requires smartly :)
gsub_file 'app/assets/javascripts/application.js', %r{^//= require_tree .\n}, ''

# Setup use of Foreman
gem 'foreman'
template 'Procfile'

# Setup use of Guard and Spork
@spork_port = ask("What port number do you want to use for Spork? [8989]")
@spork_port = "8989" if @spork_port.blank?
template 'Guardfile'
template 'test/test_helper.rb', force: true

# Install gems (so the generators below won't complain about missing gems)
run 'bundle install'

# Remove the default application layout and add a new one using Haml
remove_file 'app/views/layouts/application.html.erb'
template 'app/views/layouts/application.html.haml'
template 'app/assets/javascripts/html5.js'

# Setup new HomeController as the application root
generate :controller, "home"
template 'app/views/home/index.html.haml'
template 'app/controllers/home_controller.rb', force: true
remove_file 'public/index.html'
gsub_file 'config/routes.rb', %r{^  # root :to => 'welcome#index'$}, "  root to: 'home#index'"

# Set the project in a new Git repository
git :init
git add: '.', commit: '-m "Initial commit"'
