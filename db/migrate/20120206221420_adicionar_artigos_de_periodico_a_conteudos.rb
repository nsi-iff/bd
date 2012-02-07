class AdicionarArtigosDePeriodicoAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.string :subtitulo
      t.string :nome_periodico
      t.string :editora
      t.string :fasciculo
      t.integer :volume_publicacao
      t.integer :data_publicacao
      t.string :local_publicacao
      t.string :pagina_inicial
      t.string :pagina_final
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :subtitulo
      t.remove :nome_periodico
      t.remove :editora
      t.remove :fasciculo
      t.remove :volume_publicacao
      t.remove :data_publicacao
      t.remove :local_publicacao
      t.remove :pagina_inicial
      t.remove :pagina_final
    end
  end
end
