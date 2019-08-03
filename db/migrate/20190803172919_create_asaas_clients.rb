class CreateAsaasClients < ActiveRecord::Migration[5.2]
  def change
    create_table :asaas_clients do |t|
      t.integer :client_id, null: false

      t.timestamps
    end
  end
end
