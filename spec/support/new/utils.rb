module DigitalLibrary
  module SpecHelpers
    module Utils
      def arquivo_para_conteudo(tipo = :odt)
        { link: '',
          arquivo: ActionDispatch::Http::UploadedFile.new({
                filename: 'arquivo.odt',
                type: 'application/vnd.oasis.opendocument.text',
                tempfile: File.new(Rails.root + 'spec/resources/manual.odt')
            })}
      end
    end
  end
end
