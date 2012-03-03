class CreateSubAreas < ActiveRecord::Migration
  def change
    create_table :sub_areas do |t|
      t.string :nome
      t.references :area

      t.timestamps
    end
  end
end
