class TagsController < App

  get '/:id-:name' do |id, name|
    @snippets = Tag.find(id).snippets.recent.page(params[:page])
    @tag = Tag.find(id)
    view :'tags/show'
  end

end
