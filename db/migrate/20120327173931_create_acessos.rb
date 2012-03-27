class CreateAcessos < ActiveRecord::Migration
  def change
    create_table :acessos do |t|
      t.date :data
      t.integer :quantidade

      t.timestamps
    end
  end
end
