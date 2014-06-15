require_relative 'config/init'

class App < Sinatra::Base
  include AssetsConcern
  enable :logging, :session
  register Sinatra::Partial
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/app/views'

  # Slim templates
  Slim::Engine.set_default_options use_html_safe: true
  set :slim, layout_engine:  :slim,
             layout:         :'layouts/default',
             disable_escape: false,
             use_html_safe:  true,
             pretty:         App.environment == :development
  set :partial_template_engine, :slim

  # Rails-style form methods
  use Rack::MethodOverride

  configure :development do
    require 'pry'
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload 'app/**/*.rb'
    also_reload 'lib/**/*.rb'
    also_reload 'conf/**/*.rb'
    set :raise_errors, true
  end

  helpers Sinatra::ContentFor
  helpers AppHelpers
  helpers WillPaginate::Sinatra::Helpers

  def current_user
    User.where('id = ?', session[:user_id]).first if session[:user_id]
  end

  def meta(key, value = nil)
    if value
      content_for key do
        value
      end
    else
      yield_content key
    end
  end

  def has_meta?(key)
    content_for?(key)
  end

  def flash(key, value)
    fail "Invalid key '#{key}'" unless [ :info, :error ].include?(key)
    response.set_cookie "flash_#{key}", value: I18n.t(value), path: '/'
  end

  def view(template, options={})
    slim template.to_sym, options
  end

  def protected!
    unless current_user
      session[:redirect_back] = request.path
      flash :info, 'login.required'
      redirect '/login' 
    end
  end

  def redirect_back
    redirect session.delete(:redirect_back) { '/' }
  end

  error do
    slim :'errors/500'
  end

  not_found do
    slim :'errors/404'
  end

  error ActiveRecord::RecordNotFound do
    slim :'errors/404'
  end

  before do
    I18n.locale = params[:locale] || I18n.default_locale
  end
end

require_relative 'config/boot'
