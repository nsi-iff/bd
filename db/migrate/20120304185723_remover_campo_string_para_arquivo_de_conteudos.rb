class RemoverCampoStringParaArquivoDeConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.remove :arquivo
    end
  end

  def down
    change_table :conteudos do |t|
      t.string :arquivo
    end
  end
end
