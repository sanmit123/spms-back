class CreateUserTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.timestamps
    end
  end
end
