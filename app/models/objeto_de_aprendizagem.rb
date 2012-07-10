class ObjetoDeAprendizagem < Conteudo
  index_name 'conteudos'
  has_and_belongs_to_many :cursos
  has_many :eixos_tematicos, :through => :cursos, :uniq => true
  belongs_to :idioma

  attr_accessible :palavras_chave, :tempo_aprendizagem, :curso_ids, :novas_tags,
                  :idioma_id

  def nomes_dos_eixos_tematicos
    if eixos_tematicos.present?
      eixos_tematicos.
        map(&:nome).
        sort.
        to_sentence(two_words_connector: ' e ', last_word_connector: ' e ')
    end
  end

  def nome_dos_cursos
    if cursos.present?
      cursos.
        map(&:nome).
        sort.
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

  def tipo_de_arquivo_importa?
    false
  end

  def self.nome_humanizado
    'Objeto de Aprendizagem'
  end

  def arquivo_attributes=(args)
    args.reverse_merge!(conteudo: self)
    super
  end
end
