ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])


%w(config/init app/models app/controllers).each do |name|
  Dir[File.join(name, '**/*.rb')].each do |file|
    require_relative "../#{file}"
  end
end
