source 'https://rubygems.org'
puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['~> 3.3.0']

gem 'puppet', puppetversion

group :test do
  gem 'rake', '~> 10.1.0'
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-puppet', '~> 0.1.6'
  gem 'puppetlabs_spec_helper', '~> 0.4.1'
  gem 'puppet-lint', '~> 0.3.2'
end
