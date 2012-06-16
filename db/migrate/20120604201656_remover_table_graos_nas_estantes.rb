class RemoverTableGraosNasEstantes < ActiveRecord::Migration
  def up
    drop_table :graos_nas_estantes
  end

  def down
    create_table :graos_nas_estantes, id: false do |t|
      t.references :usuario
      t.references :grao
    end
  end
end
