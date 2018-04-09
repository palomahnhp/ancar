source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'

gem 'pg', '~> 0.18.3'# Use postgresqlas the database for Active Record
gem 'ancestry', '~> 2.2'  # Organise ActiveRecord model into a tree structure
gem 'pg_search', '~> 1.0'  # scopes that take advantage of PostgreSQL's full text search

gem 'sass-rails', '5.0.6' # Use SCSS for stylesheets
gem 'foundation-rails', '6.2.4.0' # Foundation on Sass/Compass
gem 'foundation_rails_helper', '~> 2.0'

gem 'uglifier', '>= 1.3.0' # Compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0' # CoffeeScript for .coffee assets and views
gem 'jquery-ui-rails', '~> 5.0'

gem 'jquery-rails', '~> 4.2' # Use jquery as the JavaScript library
gem 'turbolinks', '2.5.3' # Following links in your web application faster.
gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease.
gem 'initialjs-rails', '0.2.0.1'

# bundle exec rake index.html.erb:rails generates the API under index.html.erb/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise', '~> 3.5'
# Roles library without any authorization enforcement supporting scope on resource objects (instance or class).
gem 'rolify', '~> 5.1'
gem 'faraday', '~> 0.9.2'
gem 'cancancan', '~> 1.15' # simple authorization solution for Rails which is decoupled from user roles.

gem 'bcrypt', '~> 3.1' # hashing algorithm
gem 'kaminari', '~> 0.17.0' # A Scope & Engine based paginator

gem 'responders', '~> 2.3' # A set of responders modules to dry up your Rails 4.2+ app.

# gem 'rinku', require: 'rails_rinku' # auto-link rails, sanityze html
gem 'savon', '~> 2.11' # SOAP client
gem 'dalli', '~> 2.7' # mem cached client

gem 'rollbar', '~> 2.8.0' # exception tracking for ruby

# ActiveRecord backend for Delayed::Job,
gem 'delayed_job_active_record', '~> 4.1.0'
gem 'daemons', '~> 1.2' # wrap existing ruby scripts to be run as a daemon.

gem 'whenever', require: false # Clean ruby syntax for writing and deploying cron jobs (scheduled jobs).

# gem 'groupdate', '~> 3.1'   # group temporary data
# gem 'tolk', '~> 2.0' # Web interface for translations

gem 'browser', '~> 2.3' # browser detection
gem 'turnout', '~> 2.4' # put your Rails application into maintenance mode
gem 'redcarpet', '~> 3.3' # extensible Markdown to (X)HTML parser

# Use Unicorn as the app server
gem 'unicorn', '~> 5.2'

# to read and write Spreadsheet Documents. As of version 0.6.0, only Microsoft Excel compatible spreadsheets are supported
gem 'spreadsheet', '~> 1.1', '>= 1.1.2'

gem "roo", "~> 2.7.0"
gem "roo-xls"

# Create beautiful Javascript charts with one line of Ruby
gem 'chartkick', '~> 2.2'

# Wicked PDF uses the shell utility wkhtmltopdf to serve a PDF file to a user from HTML.
gem 'wicked_pdf', '~> 1.1'

# Because wicked_pdf is a wrapper for wkhtmltopdf, you'll need to install that, too.
gem 'wkhtmltopdf-binary', '~> 0.12.3.1'

gem 'rails_admin', '~> 1.1' # Rails engine that provides an easy-to-use interface for managing your data

# TDS library for Ruby using DB-Library. Developed for the ActiveRecord SQL Server adapter.
# gem 'tiny_tds', '~> 2.1', '>= 2.1.1'
# ActiveRecord SQL Server Adapter. SQL Server 2012 and upward.
# gem 'activerecord-sqlserver-adapter', '~> 4.1'

gem 'ransack'
gem 'sidekiq'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails', '~> 3.3' # Trsting framework for Rails
  gem 'capybara' # integration testing tool for rack based web applications.
  gem "factory_bot_rails"

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
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'rubocop-rspec', '~> 1.22.1', require: false
end
