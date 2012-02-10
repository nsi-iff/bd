class ObjetoDeAprendizagem < Conteudo
  has_and_belongs_to_many :eixos_tematicos
  belongs_to :idioma

  def nomes_dos_eixos_tematicos
    if eixos_tematicos.present?
      eixos_tematicos.
        map(&:nome).
        to_sentence(two_words_connector: ' e ', last_word_connector: ' e ')
    end
  end

  def nomes_das_novas_tags
    if novas_tags.present?
      novas_tags.
        split("\n").
        map(&:strip).
        to_sentence(two_words_connector: ' e ', last_word_connector: ' e ')
    end
  end

  def descricao_idioma
    idioma.try(:descricao)
  end
end
