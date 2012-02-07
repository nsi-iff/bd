class AdicionarArtigosDePeriodicoAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      # t.string :subtitulo  ---> artigo de evento
      t.string :nome_periodico
      # t.string :editora ---> artigo de evento
      t.string :fasciculo
      t.integer :volume_publicacao
      t.integer :data_publicacao
      # t.string :local_publicacao ---> artigo de evento
      # t.string :pagina_inicial ---> artigo de evento
      # t.string :pagina_final ---> artigo de evento
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :nome_periodico
      t.remove :fasciculo
      t.remove :volume_publicacao
      t.remove :data_publicacao
    end
  end
end
