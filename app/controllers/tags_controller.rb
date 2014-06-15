class TagsController < App

  get '/:id-:name' do |id, name|
    @snippets = Tag.find(id).snippets.recent.page(params[:page])
    @tag = Tag.find(id)
    redirect @tag.uri, 301 unless @request.path == @tag.uri
    view :'tags/show'
  end

end
