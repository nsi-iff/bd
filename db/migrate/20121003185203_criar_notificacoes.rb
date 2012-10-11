class CriarNotificacoes < ActiveRecord::Migration
  def up
    create_table :notificacoes do |t|
      t.text :mensagem
      t.references :conteudo, :usuario

      t.timestamps
    end
  end

  def down
    drop_table :notificacoes
  end
end
