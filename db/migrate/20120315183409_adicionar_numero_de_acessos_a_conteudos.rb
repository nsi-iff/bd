class AdicionarNumeroDeAcessosAConteudos < ActiveRecord::Migration
  def up
    add_column :conteudos, :numero_de_acessos, :integer, :default => 0
  end

  def down
    remove_column :conteudos, :numero_de_acessos
  end
end
