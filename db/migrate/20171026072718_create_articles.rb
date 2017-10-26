class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references  :snapshot
      t.string      :title
      t.datetime    :published_at
      t.decimal     :sentiment, precision: 8, scale: 6
      t.string      :dictionary_hash
      t.timestamps
    end
  end
end
