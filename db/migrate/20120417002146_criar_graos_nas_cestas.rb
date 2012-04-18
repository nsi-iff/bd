class CriarGraosNasCestas < ActiveRecord::Migration
  def up
    create_table :graos_nas_cestas, id: false do |t|
      t.references :grao
      t.references :usuario
    end
  end

  def down
    drop_table :graos_nas_cestas
  end
end
