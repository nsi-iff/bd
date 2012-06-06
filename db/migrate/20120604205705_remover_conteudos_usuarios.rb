class RemoverConteudosUsuarios < ActiveRecord::Migration
  def up
    drop_table :conteudos_usuarios
  end

  def down
    create_table :conteudos_usuarios, id: false do |t|
      t.references :usuario, :conteudo
    end
  end
end
