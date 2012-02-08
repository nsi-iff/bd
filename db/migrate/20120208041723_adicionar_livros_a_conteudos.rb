class AdicionarLivrosAConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.boolean :traducao, default: false
      t.integer :numero_edicao
      t.integer :numero_paginas
    end
  end

  def down
    change_table :conteudos do |t|
      t.remove :traducao
      t.remove :numero_edicao
      t.remove :numero_paginas
    end
  end
end
