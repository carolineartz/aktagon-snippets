require 'pry'
require 'slim'
require 'i18n'
require 'mysql2'
require 'sprockets'
require 'andand'
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'active_support/core_ext'
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate/view_helpers/sinatra'

require './lib/env'

#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

%w(app/helpers app/concerns).each do |name|
  Dir[File.join(name, '**/*.rb')].each do |file|
    require_relative "../#{file}"
  end
end
