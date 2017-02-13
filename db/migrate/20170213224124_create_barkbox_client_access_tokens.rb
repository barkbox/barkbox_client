class CreateBarkboxClientAccessTokens < ActiveRecord::Migration
  def change
    create_table :barkbox_client_auth_tokens do |t|
      t.integer   :barkbox_user_id, null: false
      t.string    :access_token, null: false
      t.string    :email
      t.timestamp :last_verified_at
      t.timestamps null: false
    end
  end
end
