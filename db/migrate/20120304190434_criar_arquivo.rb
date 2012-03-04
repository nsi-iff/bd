class CriarArquivo < ActiveRecord::Migration
  def up
    create_table :arquivos do |t|
      t.string :nome
      t.string :key
      t.string :mime_type
      t.references :conteudo

      t.timestamps
    end
  end

  def down
    drop_table :arquivos
  end
end
