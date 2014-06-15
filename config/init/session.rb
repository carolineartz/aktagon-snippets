secret = ENV['SESSION_SECRET']
fail "You need a SESSION_SECRET in .env.#{App.environment}" unless secret
App.use Rack::Session::Cookie,
        key: 'snippets_cookie',
        path: '/',
        secret: secret
# HTML forms now require:
# input name="authenticity_token" value=session[:csrf] type="hidden"
App.use Rack::Protection::AuthenticityToken 
