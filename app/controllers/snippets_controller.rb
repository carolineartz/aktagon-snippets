class SnippetsController < App
  #
  # PUBLIC
  #
  get '/:id-:name?' do |id, name|
    @snippet = Snippet.find(id)
    redirect @snippet.uri, 301 unless @request.path == @snippet.uri
    view :'snippets/show'
  end

  get '/:id-:name/raw.?:filetype?' do |id, name, filetype|
    headers['X-Frame-Options'] = ''
    @snippet = Snippet.find(id)
    if filetype == 'json'
      content_type :json
      @snippet.raw(false).to_json
    else
      view 'snippets/raw', layout: :"layouts/text"
    end
  end

  #
  # PROTECTED
  # 

  get '/new' do
    protected!
    @snippet = Snippet.new
    new
  end

  post '/new' do
    protected!
    @snippet = current_user.snippets.new(snippet_params)
    if @snippet.save
      flash :info, 'snippet.created'
      redirect @snippet.uri
    else
      new
    end
  end

  put '/:id-:name?/edit' do |id, name|
    protected!
    @snippet = current_user.snippets.find(id)
    if @snippet.update_attributes(snippet_params)
      flash :info, 'snippet.updated'
      redirect @snippet.uri(:edit)
    else
      edit
    end
  end

  get '/:id-:name?/edit' do |id, name|
    protected!
    @snippet = current_user.snippets.find(id)
    edit
  end

  get '/:id-:name?/delete' do |id, name|
    protected!
    @snippet = current_user.snippets.find(id)
    view :'snippets/delete'
  end

  delete '/:id-:name?/delete' do |id, name|
    protected!
    current_user.snippets.destroy(id)
    flash :info, 'snippet.deleted'
    redirect '/'
  end

  protected

  def edit
    @languages = Language.all
    view 'snippets/edit'
  end

  def new
    @languages = Language.all
    view 'snippets/new'
  end

  def snippet_params
    allowed = %w(title body tag_list language_id tag_list lock_version)
    params.fetch('snippet').slice(*allowed)
  end
end
