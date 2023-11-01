source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "autoprefixer-rails"
gem "bootsnap", require: false
gem "bootstrap", "~> 5.2"
gem "devise"
gem "dotenv"
gem "font-awesome-sass", "~> 6.1"
gem "geocoder"
gem "jbuilder"
gem "importmap-rails"
gem 'mapbox-sdk', "~> 2.3", ">= 2.3.3"
gem "pg", "~> 1.1"
gem 'pg_search'
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.8"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
# "OpenAI"
gem "openai", "~> 0.2.0"
gem "ruby-openai", "~> 5.1"

# gem "redis", "~> 4.0"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "pry-byebug"
  # gem "rack-mini-profiler"
  # gem "spring"
end

group :test do
  gem "capybara"
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.0.0'
  gem "rubocop-rspec"
  gem "rubocop-capybara"
  gem "selenium-webdriver"
	gem 'shoulda-matchers', '~> 5.0'
  gem 'warden-rspec-rails'
  gem "webdrivers"
end
