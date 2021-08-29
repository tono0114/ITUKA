class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :post_id
      t.integer :user_id
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps
    end
  end
end
