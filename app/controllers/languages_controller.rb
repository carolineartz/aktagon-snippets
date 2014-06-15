class LanguagesController < App

  get '/:id-:name' do |id, name|
    @language = Language.find(id)
    @snippets = @language.snippets.recent.page(params[:page])
    redirect @language.uri, 301 unless @request.path == @language.uri
    view :'languages/show'
  end

end
