require "better_errors"

if App.environment == :development
  App.use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
  BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
end
