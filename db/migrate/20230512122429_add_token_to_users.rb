class AddTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :api_key, :string

    User.find_each do |user|
      api_key = SecureRandom.base58(24)
      user.update_columns(api_key: api_key)
    end

    change_column :users, :api_key, :string, unique: true, null: false

  end
end
