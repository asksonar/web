raise 'Ruby version must be greater than or equal to 2.1.2' unless  RUBY_VERSION >= '2.1.2'

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
#gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#######################################
# insert new packages below this line #
#######################################

# use postgres instead of sqlite3
gem 'pg'
# bootstrap_form_for helper
gem 'bootstrap_form'
# navbar_item helper
gem 'rails_bootstrap_navbar'
# used in ActiveRecordHashids for obfuscating ids
gem 'hashids'
# user login framework
gem 'devise'
# better server than webrick
gem 'thin'
# Use Unicorn as the primary app server
gem 'unicorn'

source 'https://rails-assets.org' do
  # bootstrap with sass variables
  gem 'rails-assets-bootstrap-sass'
  # more icon elements than bootstrap has
  gem 'rails-assets-fontawesome'
  # amcharts chart library
  gem 'rails-assets-handlebars'
  # makes our textarea elements dynamically resize as people type
  gem 'rails-assets-amcharts'
  # videojs html5 video library
  gem 'rails-assets-videojs', '~> 4'
  # videojs plugin for markers
  gem 'rails-assets-videojs-markers'
  # handlebars javascript templating library
  gem 'rails-assets-autosize'
  # lets us copy to clipboard
  gem 'rails-assets-zeroclipboard'
  # gives us nice-looking error messages, configured in application.html.erb
  gem 'rails-assets-remarkable-bootstrap-notify'
  # add animations for notify
  gem 'rails-assets-animate.css'
end

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  #gem 'debugger'
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # be more clever about reloading code to speed up refreshes
  #gem 'rails-dev-tweaks', '~> 1.1'
end

group :production do
  gem 'rails_12factor'
end
