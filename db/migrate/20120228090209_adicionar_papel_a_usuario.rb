class AdicionarPapelAUsuario < ActiveRecord::Migration
  def up
    create_table :papeis_usuarios, :id => false do |t|
      t.references :usuario, :papel
    end
  end

  def down
    drop_table :papeis_usuarios
  end
end
