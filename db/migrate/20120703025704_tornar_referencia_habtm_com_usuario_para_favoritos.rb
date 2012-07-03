class TornarReferenciaHabtmComUsuarioParaFavoritos < ActiveRecord::Migration
  def up
    remove_column :referencias, :usuario_id
    create_table :favoritos, id: false do |t|
      t.references :usuario
      t.references :referencia
    end
  end

  def down
    drop_table :favoritos
    add_column :referencias, :usuario_id, :integer
    add_index :referencias, :usuario_id
  end
end
