# rails new app_name -m https://github.com/brunowernimont/rails-template/raw/master/base.rb --skip-test-unit

run "echo TODO > README"

run 'rm public/index.html'
run 'rm public/images/rails.png'
run 'mkdir public/images/uploads'
run 'rm .gitignore'
run 'rm Gemfile'

file 'Gemfile', <<-EOF
source 'http://rubygems.org'

gem 'rails', '3.0.5'
gem 'seo_meta_builder'
gem 'devise', '>= 1.2.rc'
gem 'formtastic'
gem 'tiny_mce'
gem 'paperclip'
gem "will_paginate", ">= 3.0.pre2"
gem 'haml'
gem "haml-rails"
gem 'compass'
gem 'tabletastic', '>= 0.2.1'
gem 'jquery-rails'
gem "crummy"

group :development do
  gem 'capistrano'
  gem 'rails3-generators'
  gem 'hpricot'
  gem 'ruby_parser'
end

group :development, :test do
  gem 'rspec', '>= 2.0.0.rc'
  gem 'rspec-rails', '>= 2.0.0.rc'
  gem 'factory_girl_rails'
  gem 'autotest'
end

group :production do
  #gem 'passenger'
  #gem 'thin'
  #gem 'unicorn'
  #gem 'mongrel'
  gem 'smurf'
end
EOF

db = nil

if yes? "Do you want Mysql ?"
  gem 'mysql2'
  db = 'mysql'
else
  if yes? "Do you want Mongoid ?"
    gem "mongoid", "2.0.0.rc.6"
    gem "bson_ext", "~> 1.2"
    db = 'mongoid'
  else
    gem 'sqlite3-ruby', :require => 'sqlite3'
    db = 'sqlite'
  end
end

run 'bundle install'

case db
when 'mysql'
  run "cp config/database.yml config/database.yml.sample"
when 'mongoid'
  run 'rm config/database.yml'
  run "cp config/mongoid.yml config/mongoid.yml.sample"
  run 'rails generate mongoid:config'
else
  run "cp config/database.yml config/database.yml.sample"
end

generate :rspec
run 'compass init rails .'

inside('app/stylesheets/') { run 'rm *' }

if yes?('Du you want jquery ?')
  if yes?('Du you want jquery-ui ?')
    run 'rails generate jquery:install --ui'
  else
    run 'rails generate jquery:install'
  end
end

generators = <<-GENERATORS

    config.generators do |g|
      g.integration_tool :rspec, :fixture => true, :views => true
      g.test_framework :rspec, :fixture => true, :views => false
      g.template_engine :haml
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
GENERATORS

application generators

file ".gitignore", <<-EOF
.DS_Store
log/*.log
tmp/**/*
.bundle
db/*.sqlite3
config/database.yml
config/mongoid.yml
assets/*
.idea
.generators
public/images/uploads
EOF