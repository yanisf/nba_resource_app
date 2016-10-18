class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :vote
      t.references :user, index: true
      t.references :article, index: true

      t.timestamps
    end
  end
end
