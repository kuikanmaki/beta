if RUBY_VERSION =~ /1.9.3/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '3.2.15'


gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'jquery-rails', '2.0.2'
gem 'thin'
gem "paperclip", "~> 3.0"
gem "nokogiri"
gem "sanitize"
gem 'rmagick', '2.13.2', :require => 'RMagick'
gem "d3-rails"
gem 'underscore-rails'
gem 'make_voteable'
gem 'public_activity'

gem 'bootstrap-wysihtml5-rails'
gem "friendly_id", "~> 4.0.10"
gem 'opentok'

gem 'mailboxer'
gem 'messaging', git: 'git://github.com/frodefi/rails-messaging.git'
gem 'haml'

gem 'simple_form'
gem 'country_select'

gem 'sass-rails', '>= 3.1.4'
gem 'bootstrap-sass', '~> 3.0.2.0'

gem 'aws-sdk'

#gem 'less'
#gem 'less-rails-bootstrap'
#gem 'less-rails' 


  gem 'coffee-rails', '3.2.2'
 

group :development, :test do
  gem 'pg', '0.12.2'
  #gem 'sqlite3', '1.3.5' #
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '1.2.1'
  gem 'guard-spork', '1.2.0'
  gem 'childprocess', '0.3.6'
  gem 'spork', '0.9.2'
  gem 'habtm_generator'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier', '1.2.3'
  gem 'therubyracer', '~> 0.10.2'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
  # gem 'launchy', '2.1.0'
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'
end

group :production do
  gem 'pg', '0.12.2'
end