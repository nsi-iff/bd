class MudarDeGraosParaReferenciasNasCestas < ActiveRecord::Migration
  def up
    drop_table :graos_nas_cestas
    create_table :referencias_nas_cestas, id: false do |t|
      t.references :usuario
      t.references :referencia
    end
  end

  def down
    drop_table :referencias_nas_cestas
    create_table :graos_nas_cestas, id: false do |t|
      t.references :grao
      t.references :usuario
    end
  end
end
