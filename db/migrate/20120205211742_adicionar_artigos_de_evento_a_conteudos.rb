class AdicionarArtigosDeEventoAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.string :nome_evento
      t.string :local_evento
      t.integer :numero_evento
      t.integer :ano_evento
      t.string :editora
      t.integer :ano_publicacao
      t.string :local_publicacao
      t.string :titulo_anais
      t.integer :pagina_inicial
      t.integer :pagina_final
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :nome_evento
      t.remove :local_evento
      t.remove :numero_evento
      t.remove :ano_evento
      t.remove :editora
      t.remove :ano_publicacao
      t.remove :local_publicacao
      t.remove :titulo_anais
      t.remove :pagina_inicial
      t.remove :pagina_final
    end
  end
end
