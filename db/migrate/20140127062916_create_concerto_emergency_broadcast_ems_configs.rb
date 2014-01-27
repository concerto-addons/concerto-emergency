class CreateConcertoEmergencyBroadcastEmsConfigs < ActiveRecord::Migration
  def change
    create_table :concerto_emergency_broadcast_ems_configs do |t|
      t.integer :template_id
      t.integer :feed_id

      t.timestamps
    end
  end
end
