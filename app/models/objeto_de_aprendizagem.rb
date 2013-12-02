class ObjetoDeAprendizagem < Conteudo
  index_name 'conteudos'
  has_and_belongs_to_many :cursos, join_table: 'cursos_objetos_de_aprendizagem'
  has_many :eixos_tematicos, -> { uniq }, :through => :cursos
  belongs_to :idioma

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

  def arquivo=(uploaded)
    @arquivo_uploaded = uploaded
    @arquivo_base64 = Base64.encode64(@arquivo_uploaded.read) if @arquivo_uploaded
  end

  def granularizar
    if arquivo.video?
      granularizar_video
    else
      config = Rails.application.config.cloudooo_configuration
      cloudooo.granulate(
        sam_uid: arquivo.key,
        filename: arquivo.nome,
        callback: config[:callback_url],
        verb: config[:callback_verb])
    end
  end

  def granularizar_video
    config = Rails.application.config.videogranulate_configuration
    response = videogranulate.granulate(:sam_uid => arquivo.key,
      :filename => arquivo.nome,
      callback: config[:callback_url],
      verb: config[:callback_verb])
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

  def graos_video
    graos.select(&:video?)
  end
end
