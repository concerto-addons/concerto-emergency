class CreateConcertoEmergencyBroadcastAlerts < ActiveRecord::Migration
  def change
    create_table :concerto_emergency_broadcast_alerts do |t|
      t.string :body

      t.timestamps
    end
  end
end
