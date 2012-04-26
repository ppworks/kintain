source 'https://rubygems.org'

gem 'rails', '3.2.3'
gem 'jquery-rails'
gem 'thin'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'heroku'
  gem 'foreman'
end

group :development, :test do
  gem 'mysql2'
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => false
  gem 'taps'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end
