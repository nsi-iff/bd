class AlterarTipoDeDataPublicacaoParaDateEmConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.remove :data_publicacao
      t.date :data_publicacao
    end
  end

  def down
    change_table :conteudos do |t|
      t.change :data_publicacao, :string
    end
  end
end
