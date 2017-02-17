class CreateAuth < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.integer   :barkbox_user_id, null: false
      t.string    :access_token, null: false
      t.timestamp :access_token_expires_at
      t.string    :refresh_token
      t.string    :email
      t.timestamps null: false
    end
    add_index :auths, :barkbox_user_id
    add_index :auths, :access_token, unique: true
  end
end
