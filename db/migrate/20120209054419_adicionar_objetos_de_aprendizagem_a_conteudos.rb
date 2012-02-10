class AdicionarObjetosDeAprendizagemAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.string :palavras_chave
      t.string :tempo_aprendizagem
      t.text :novas_tags
      t.references :idioma
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :palavras_chave
      t.remove :tempo_aprendizagem
      t.remove :novas_tags
      t.remove :idioma_id
    end
  end
end
