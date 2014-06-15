class DbSchema < ActiveRecord::Migration
  def up
    create_table :languages, force: true do |t|
      t.string   :name
      t.string   :external_name
      t.integer  :snippets_count, default: 0
      t.timestamps
    end

    add_index :languages, :name, unique: true
    add_index :languages, :external_name, unique: true

    create_table :snippets, force: true do |t|
      t.references :user, index: true
      t.string     :title
      t.binary     :body,            limit: 16777215
      t.binary     :rendered_body,   limit: 16777215
      t.references :language, index: true
      t.integer    :version,         default: 0
      t.integer    :lock_version,    default: 0
      t.timestamps
    end

    add_index :snippets, :title

    create_table :taggings, force: true do |t|
      t.integer  :tag_id
      t.integer  :taggable_id
      t.string   :taggable_type
      t.timestamps
    end

    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type], unique: true

    create_table :tags, force: true do |t|
      t.string :name
      t.integer:snippets_count, default: 0
      t.timestamps
    end

    add_index :tags, :name, unique: true

    create_table :users, force: true do |t|
      t.string   :login
      t.string   :email
      t.string   :password_hash
      t.string   :password_salt
      t.timestamps
    end

    add_index :users, :login, unique: true
    add_index :users, :email, unique: true
  end
end
