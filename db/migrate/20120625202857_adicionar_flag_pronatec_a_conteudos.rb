class AdicionarFlagPronatecAConteudos < ActiveRecord::Migration
  def up
    add_column :conteudos, :pronatec, :boolean
  end

  def down
    remove_column :conteudos, :pronatec
  end
end
