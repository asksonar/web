ruby "2.2.0"

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
# add invitation support for devise
gem 'devise_invitable'
# user authorization framework
gem 'pundit'
# better server than webrick
gem 'thin'
# needs to declared here as well as gemspec for resque-web to work
gem 'resque', '~> 1'
gem 'resque-web', require: 'resque_web'
# use s3 calls
gem 'aws-sdk'
# track metrics using mixpanel
gem 'mixpanel-ruby'
# parse user agent for passing to mixpanel
gem 'user_agent_parser'
# sanitizer for non-markup
gem 'sanitize'
# gives us local_time and local_time_ago to handle timezones via javascript
gem 'local_time'
# lets us do bulk imports via the ModelClass.import(array_of_models) function
gem 'activerecord-import'
# pagination gem, with bootstrap styling
gem 'kaminari-bootstrap'
# add scheduler tabs for resque as well
gem 'resque-scheduler-web'
# consume restful web services
gem 'httparty'

source 'https://rails-assets.org' do
  # bootstrap with sass variables
  gem 'rails-assets-bootstrap-sass'
  # more icon elements than bootstrap has
  gem 'rails-assets-fontawesome', '4.3.0' # verison 4.4.0 uses /fonts instead of /assets, which breaks
  # handlebars javascript templating library
  gem 'rails-assets-handlebars'
  # makes our textarea elements dynamically resize as people type
  gem 'rails-assets-autosize'
  # lets us copy to clipboard
  gem 'rails-assets-zeroclipboard'
  # gives us nice-looking error messages, configured in application.html.erb
  gem 'rails-assets-remarkable-bootstrap-notify'
  # add animations for notify
  gem 'rails-assets-animate.css'
  # add backfill support for History.replaceState and its ilk
  gem 'rails-assets-history'
  # add helper to manipulate URLs
  gem 'rails-assets-URIjs'
  # add jqueryui for animate controls
  gem 'rails-assets-jqueryui'
  # add modulejs so we don't need to reorder javascript files
  gem 'rails-assets-modulejs'
  # much nicer looking selects by turning them into button dropdowns
  gem 'rails-assets-bootstrap-select'
  # pivot table implementation
  gem 'rails-assets-pivottable'
  # Bootstrap Sub-Menus
  gem 'rails-assets-bootstrap-submenu'
  # Reorderable drag-and-drop lists
  gem 'rails-assets-Sortable'
  # Parse, validate, manipulate, and display dates
  gem 'rails-assets-moment'
  # Javascript SVG parser and renderer on Canvas
  gem 'rails-assets-canvg'
end

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  #gem 'debugger'
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'require_reloader'

  gem 'rspec-rails'
  # be more clever about reloading code to speed up refreshes
  #gem 'rails-dev-tweaks', '~> 1.1'
end

# needed by heroku
# group :production do
#   gem 'rails_12factor'
# end
