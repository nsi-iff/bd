class CreateIdiomas < ActiveRecord::Migration
  def change
    create_table :idiomas do |t|
      t.string :sigla
      t.string :descricao

      t.timestamps
    end
  end
end
