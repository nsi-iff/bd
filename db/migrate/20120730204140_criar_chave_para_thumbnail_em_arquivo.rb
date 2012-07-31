class CriarChaveParaThumbnailEmArquivo < ActiveRecord::Migration
  def up
    change_table :arquivos do |t|
      t.string :thumbnail_key
    end
  end

  def down
    change_table :arquivos do |t|
      t.remove :thumbnail_key
    end
  end
end
