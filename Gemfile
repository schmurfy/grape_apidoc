source 'https://rubygems.org'

gemspec

gem 'rake'
gem 'grape', :git => 'git://github.com/schmurfy/grape.git', :branch => 'validations'

group(:test) do
  gem 'thin'
  
  gem 'schmurfy-bacon'
  gem 'mocha',          '~> 0.10.0'
  gem 'factory_girl'
  
  gem 'simplecov'
  gem 'guard'
  gem 'guard-bacon'
  gem 'rb-fsevent'
  gem 'growl'
  
  # http
  gem 'em-http-request', '~> 1.0.0'
  gem 'eventmachine', '~> 1.0.0.rc'
  gem 'em-synchrony'
end
