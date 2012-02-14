class AdicionarTrabalhosDeObtencaoDeGrauAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      # t.string subtitulo ---> artigo de evento
      # t.integer numero_paginas ---> livro
      t.date :data_defesa
      t.string :instituicao
      t.string :local_defesa
      t.references :grau
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :data_defesa
      t.remove :instituicao
      t.remove :local_defesa
    end
  end
end

