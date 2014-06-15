require 'bundler/setup'
require 'sinatra/activerecord/rake'
require 'pry'
require './app'

Dir[File.join('lib', 'tasks', '**', '*.rake')].each do |file|
  import file
end

task :console do
  binding.pry
end

# Asset pipeline (Sprockets)
namespace :assets do
  task :precompile do
    version = Time.now.to_i 
    App.sprockets['application.js'].write_to("public/assets/application-#{version}.js")
    App.sprockets['application.css'].write_to("public/assets/application-#{version}.css")
    File.open('public/assets/version', 'w') { |f| f << version }
    puts "Done... Version #{version}"
  end
end

namespace :cache do
  task :clear do
  end
end
