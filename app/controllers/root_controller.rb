class RootController < App

  get '/' do
    @snippets = Snippet.recent.page(params[:page])
    view :index
  end

  get '/about' do
    view :about
  end

  get '/login' do
    redirect '/logout' if signed_in?
    view :login
  end

  post '/login' do
    user = User.authenticate(params[:login], params[:password])
    if user
      user_signed_in(user)
      flash :info, 'login.ok'
      redirect_back
    else
      flash :info, 'login.failed'
    end
    view :login
  end

  get '/logout' do
    user_signed_out
    flash :info, 'logout.ok'
    redirect '/'
  end

  private

  def user_signed_in(user)
    session[:user_id] = user.id
    response.set_cookie 'user', { login: user.login, id: user.id }.to_json
  end

  def user_signed_out
    session[:user_id] = nil
    response.set_cookie 'user', nil
    # Da capo
    session.clear
  end
end
