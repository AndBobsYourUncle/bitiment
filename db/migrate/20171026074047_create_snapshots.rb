class CreateSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :snapshots do |t|
      t.decimal     :sentiment, precision: 8, scale: 6
      t.string      :dictionary_hash
      t.string      :feed_list_hash
      t.timestamps
    end
  end
end
