class GraosNasEstantes < ActiveRecord::Migration
  def up
    create_table :graos_nas_estantes, id: false do |t|
      t.references :usuario
      t.references :grao
    end
  end

  def down
    drop_table :graos_nas_estantes
  end
end
