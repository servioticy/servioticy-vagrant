source 'https://rubygems.org'

group :development, :test do
  gem 'puppetlabs_spec_helper',          '0.10.3', :require => false
  gem 'rspec-puppet',                    '2.1.0',  :require => false
  gem 'rspec-core',                      '3.1.7',  :require => false
  gem 'puppet-lint-strict_indent-check', '2.0.1',  :require => false
  gem 'metadata-json-lint',                        :require => false
  gem 'rspec-puppet-facts',                        :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
    gem 'facter', facterversion, :require => false
else
    gem 'facter', :require => false
end

# vim:ft=ruby

