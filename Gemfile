source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'

gem 'pg' # Use postgresqlas the database for Active Record
gem 'ancestry' # Organise ActiveRecord model into a tree structure
gem 'pg_search'  # scopes that take advantage of PostgreSQL's full text search

gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'foundation-rails' # Foundation on Sass/Compass
gem 'foundation_rails_helper'

gem 'uglifier', '>= 1.3.0' # Compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0' # CoffeeScript for .coffee assets and views
gem 'jquery-ui-rails', '~> 5.0'

gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks', '2.5.3' # Following links in your web application faster.
gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease.
gem 'initialjs-rails', '0.2.0.1'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
# Roles library without any authorization enforcement supporting scope on resource objects (instance or class).
gem 'rolify', '~> 5.1'
gem 'faraday', '~> 0.9.2'
gem 'cancancan' # simple authorization solution for Rails which is decoupled from user roles.

# Use ActiveModel has_secure_password
gem 'kaminari' # A Scope & Engine based paginator

gem 'responders' # A set of responders modules to dry up your Rails 4.2+ app.

# gem 'rinku', require: 'rails_rinku' # auto-link rails, sanityze html
gem 'savon' # SOAP client
gem 'dalli' # mem cached client

gem 'rollbar', '~> 2.8.0' # exception tracking for ruby

# ActiveRecord backend for Delayed::Job,
gem 'delayed_job_active_record', '~> 4.1.0'
gem 'daemons' # wrap existing ruby scripts to be run as a daemon.

gem 'whenever', require: false # Clean ruby syntax for writing and deploying cron jobs (scheduled jobs).

gem 'groupdate'   # group temporary data
gem 'tolk' # Web interface for translations

gem 'browser' # browser detection
gem 'turnout' # put your Rails application into maintenance mode
gem 'redcarpet' # extensible Markdown to (X)HTML parser

# Use Unicorn as the app server
gem 'unicorn'

# to read and write Spreadsheet Documents. As of version 0.6.0, only Microsoft Excel compatible spreadsheets are supported
gem 'spreadsheet', '~> 1.1', '>= 1.1.2'

# Create beautiful Javascript charts with one line of Ruby
gem "chartkick"

# Wicked PDF uses the shell utility wkhtmltopdf to serve a PDF file to a user from HTML.
gem 'wicked_pdf'

# Because wicked_pdf is a wrapper for wkhtmltopdf, you'll need to install that, too.
gem 'wkhtmltopdf-binary'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails', '~> 3.3' # Trsting framework for Rails
  gem 'capybara' # integration testing tool for rack based web applications.
  gem 'factory_girl_rails', require: false #integration between factory_girl and rails ( DSL for defining and using factories )

  gem 'fuubar' #  RSpec progress bar formatter
  gem 'launchy' # Launching external application from within ruby programs.
  gem 'quiet_assets' # turns off Rails asset pipeline log.
  gem 'letter_opener_web', '~> 1.3.0' # Gives letter_opener an interface for browsing sent emails
  gem 'i18n-tasks' #  helps you find and manage missing and unused translations.

  #  utility and framework for executing commands in parallel on multiple remote machines, via SSH.
  gem 'capistrano', '3.5.0',           require: false
  gem "capistrano-bundler", '1.1.4',   require: false
  gem "capistrano-rails", '1.1.7',     require: false
  gem "capistrano-rvm",                require: false
  gem 'capistrano3-delayed-job', '~> 1.0'

  gem "bullet"  # kill N+1 queries and unused eager loading.
  gem "faker" # generate fake data: names, addresses, phone numbers, etc.
end

group :development do
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'coveralls', require: false
  gem 'email_spec'
  gem 'seed_dump'
  gem 'jazz_hands', :git => 'https://github.com/nixme/jazz_hands.git', branch: 'bring-your-own-debugger'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end
