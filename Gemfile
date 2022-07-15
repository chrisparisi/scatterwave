source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'sqlite3'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'jquery-rails', '~> 4.3', '>=4.3.1'

# gem 'bootstrap-sass', '~> 3.4.1'
gem 'devise', '~> 4.2'

gem 'bcrypt', platforms: :ruby

gem 'toastr-rails', '~> 1.0'

gem 'omniauth', '~> 1.6.1'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth-google-oauth2','0.6.1'

gem 'certified', '~> 1.0'

gem 'aws-sdk', '~> 2.8'
gem 'paperclip', '~> 5.1.0'

gem 'geocoder', '~> 1.4'
gem 'jquery-ui-rails', '~> 5.0'

gem 'ransack', '~> 1.7'

gem 'jquery-timepicker-rails'

#---- Scatterwave Advanced ----
gem 'fullcalendar-rails', '~> 3.4.0'
gem 'momentjs-rails', '~> 2.17.1'
gem 'twilio-ruby'#, '~> 4.11.1'

gem 'json'

gem 'rails-assets-card', source: 'https://rails-assets.org'
gem 'stripe', '~> 3.0.0'

gem 'omniauth-stripe-connect', '~> 2.10.0'

gem 'chartkick', '~> 2.2.4'

gem 'coffee-script-source', '1.8.0'

gem 'rubocop', '~> 0.57.2', require: false # autoformatting
gem 'cocoon'
gem 'simple_form'
gem 'redis', '~> 3.3.3'
gem 'will_paginate'

## Deploy Tool
gem 'mina'
gem 'mina-multistage'
gem 'figaro'