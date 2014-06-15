class Languages < ActiveRecord::Migration
  def up
    Uv.syntaxes.sort.each do |lang|
      Language.create! name: lang,
        external_name: lang
    end
    # Fix public names of languages
    Language.all.each do |lang|
      lang.update! name: lang.name.gsub(/source\.|text\./, '')
    end
    {
      :'text.html.basic' => 'html',
      :'text.plain' => 'text',
      :'source.php.cake' => 'php',
      :'source.shell' => 'shell script',
      :'source.js' => 'javascript',
      :'source.objc' => 'objective-c',
      :'source.objc++' => 'objective-c++'
    }.each do |external_name, name|
      Language.find_by!(external_name: external_name).update! name: name
    end
  end

  def down
    Language.delete_all
  end
end
