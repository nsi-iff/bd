class ConteudosUsuarios < ActiveRecord::Migration
  def up
    create_table :conteudos_usuarios, id: false do |t|
      t.references :usuario, :conteudo
    end
  end

  def down
    drop_table :conteudos_usuarios
  end
end
