# Add base directory to search paths
source_paths << "#{File.dirname(__FILE__)}/base"

# Create a development group in the Gemfile
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

# Enable Unicorn in the Gemfile
gsub_file 'Gemfile', /^# (gem 'unicorn.*)$/, '\1'

# Add default set of Gems
append_file 'Gemfile', "\n"
gem 'haml'
gem 'therubyracer'
gem 'simple_form'
gem 'inherited_resources'

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

# Remove the default application layout and add a new one using Haml
remove_file 'app/views/layouts/application.html.erb'
template "app/views/layouts/application.html.haml"

# Setup new HomeController as the application root
generate :controller, "home"
template 'app/views/home/index.html.haml'
template 'app/controllers/home_controller.rb', force: true
remove_file 'public/index.html'
gsub_file 'config/routes.rb', %r{^  # root :to => 'welcome#index'$}, "  root to: 'home#index'"

# Set the project in a new Git repository
git :init
git add: '.', commit: '-m "Initial commit"'
