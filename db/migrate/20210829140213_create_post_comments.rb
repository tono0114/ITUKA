class CreatePostComments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comments do |t|
      t.integer :post_id
      t.integer :user_id
      t.text :comment
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps
    end
  end
end
