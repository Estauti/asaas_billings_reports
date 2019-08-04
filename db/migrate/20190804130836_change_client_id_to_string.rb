class ChangeClientIdToString < ActiveRecord::Migration[5.2]
  def change
    change_column :asaas_clients, :client_id, :text, null: false
  end
end
