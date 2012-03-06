class AdicionarContribuidorAConteudos < ActiveRecord::Migration
  def up
    add_column :conteudos, :contribuidor_id, :integer
  end

  def down
    remove_column :conteudos, :contribuidor_id
  end
end
