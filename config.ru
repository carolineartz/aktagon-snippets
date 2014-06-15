require './app'

map "/" do
  run RootController
end

map "/tags" do
  run TagsController
end

map "/languages" do
  run LanguagesController
end

map "/snippets" do
  run SnippetsController
end

map "/assets" do
  run App.sprockets
end
