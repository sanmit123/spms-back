class CreateUserSessionTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid :user_id
      t.datetime :expiry_at
      t.timestamps
    end
  end
end
