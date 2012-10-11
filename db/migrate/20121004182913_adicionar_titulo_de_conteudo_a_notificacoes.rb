class AdicionarTituloDeConteudoANotificacoes < ActiveRecord::Migration
  def up
    change_table :notificacoes do |t|
      t.string :titulo_conteudo
    end
  end

  def down
    change_table :notificacoes do |t|
      t.remove :titulo_conteudo
    end
  end
end
