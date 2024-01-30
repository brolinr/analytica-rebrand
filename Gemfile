# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'active_storage_validations',           '~> 0.9.8'
gem 'activestorage-validator',              '~> 0.4.0'
gem 'bootsnap',                             '~> 1.17.1', require: false
gem 'dotenv-rails',                         '>= 2.8.1'
gem 'image_processing',                     '~> 1.2'
gem 'importmap-rails',                      '~> 2.0.1'
gem 'pg',                                   '~> 1.1'
gem 'puma',                                 '~> 5.0'
gem 'rails',                                '~> 7.0.8'
gem 'ransack', '~> 4.1'
gem 'redis',                                '~> 4.0'
gem 'sprockets-rails',                      '~> 3.4.2'
gem 'stimulus-rails',                       '~> 1.3.3'
gem 'tailwindcss-rails',                    '~> 2.3'
gem 'turbo-rails',                          '~> 1.5.0'
gem 'tzinfo-data',                          '~> 2.0.6', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug',                             '~> 11.1'
  gem 'database_cleaner-active_record',     '~> 2.1'
  gem 'debug',                              '~> 1.8', platforms: %i[mri mingw x64_mingw]
  gem 'foreman',                            '~> 0.87.2'
  gem 'rubocop',                            '~> 1.35.0'
  gem 'rubocop-performance',                '~> 1.14.3'
  gem 'rubocop-rails',                      '~> 2.14.2'
  gem 'rubocop-rspec',                      '~> 2.8'
  gem 'shoulda-matchers',                   '~> 5.3'
end

group :development do
  gem 'letter_opener',                      '~> 1.8'
  gem 'web-console',                        '~> 4.2'
end

group :test do
  gem 'capybara',                           '~> 3.40.0'
  gem 'rspec-rails',                        '~> 6.0.1'
  gem 'selenium-webdriver',                 '~> 4.17.0'
  gem 'simplecov',                          '~> 0.22.0'
  gem 'vcr',                                '~> 6.1.0'
  gem 'webdrivers',                         '~> 5.2.0'
end
