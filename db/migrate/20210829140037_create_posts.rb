class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :image_id
      t.string :country
      t.string :title
      t.text :text
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps
    end
  end
end
