module DigitalLibrary
  module SpecHelpers
    module Utils
      def arquivo_para_conteudo(tipo = :odt)
        { link: '',
          arquivo: stub(
            original_filename: 'arquivo.odt',
            content_type: 'application/vnd.oasis.opendocument.text',
            read: File.open(File.join(
              Rails.root, *%w(spec resources manual.odt))).read) }
      end
    end
  end
end
