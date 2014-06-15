class LanguagesController < App

  get '/:id-:name' do |id, name|
    @language = Language.find(id)
    @snippets = @language.snippets.recent.page(params[:page])
    view :'languages/show'
  end

end
