OpenStruct.new(YAML::load(File.open('config/database.yml'))[App.environment.to_s].symbolize_keys).tap do |config|
  ActiveRecord::Base.establish_connection(
    host: config.host,
    adapter: config.adapter,
    database: config.database,
    username: config.username,
    password: config.password
  )
end
