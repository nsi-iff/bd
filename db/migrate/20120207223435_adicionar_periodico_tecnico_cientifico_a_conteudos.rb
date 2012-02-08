class AdicionarPeriodicoTecnicoCientificoAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
#      t.string :editora ---> Artigo de Evento
      t.integer :ano_primeiro_volume
      t.integer :ano_ultimo_volume
#      t.string :local_publicacao ---> Artigo de Evento
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :ano_primeiro_volume
      t.remove :ano_ultimo_volume
    end
  end
end
