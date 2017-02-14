class CreateBarkboxClientAuth < ActiveRecord::Migration
  def change
    create_table :barkbox_client_auths do |t|
      t.integer   :barkbox_user_id, null: false
      t.string    :access_token, null: false
      t.timestamp :access_token_expires_at
      t.string    :refresh_token
      t.string    :email
      t.timestamps null: false
    end
    add_index :barkbox_client_auths, :barkbox_user_id
    add_index :barkbox_client_auths, :access_token, unique: true
  end
end
