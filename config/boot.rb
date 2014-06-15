ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)

%w(config/init app/models app/controllers).each do |name|
  Dir[File.join(name, '**/*.rb')].each do |file|
    require_relative "../#{file}"
  end
end
