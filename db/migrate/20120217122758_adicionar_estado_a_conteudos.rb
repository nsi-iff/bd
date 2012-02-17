class AdicionarEstadoAConteudos < ActiveRecord::Migration
  def up
    add_column :conteudos, :state, :string
  end

  def down
    remove_column :conteudos, :state
  end
end
