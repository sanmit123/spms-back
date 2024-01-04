class CreateQuotationTable < ActiveRecord::Migration[6.0]
  def change
    create_table :quotations, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid :performed_by_id
      t.uuid :user_id
      t.string :url
      t.timestamps
    end

    create_table :quotation_audits, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid :performed_by_id
      t.string :object
      t.uuid :object_id
      t.string :action_name
      t.jsonb :data
      t.timestamps
    end
  end
end
