class AdicionarTipoTrabalhoAConteudos < ActiveRecord::Migration
  def up
  	change_table :conteudos do |t|
      t.string :tipo_trabalho
    end
  end

  def down
  	change_table :conteudos do |t|
      t.remove :tipo_trabalho
    end
  end
end
