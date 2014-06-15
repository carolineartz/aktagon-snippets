Dir[File.join(App.root, 'config', 'locales', '*.yml')].each do |file|
  I18n.backend.load_translations(file)
end
I18n.default_locale = :en
