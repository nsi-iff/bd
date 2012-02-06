class CriarConteudos < ActiveRecord::Migration
  def up
    create_table :conteudos do |t|
      t.string :titulo
      t.string :link
      t.string :arquivo
      t.string :grande_area_de_conhecimento
      t.string :area_de_conhecimento
      t.string :campus
      t.text :direitos
      t.text :resumo

      t.string :type

      t.timestamps
    end
  end

  def down
    drop_table :conteudos
  end
end

