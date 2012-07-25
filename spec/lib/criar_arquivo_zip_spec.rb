# encoding: utf-8

require 'spec_helper'

feature 'cesta de grãos' do
  before(:each) do
    @usuario = create(:usuario)
    @livro = create(:livro, titulo: 'Quantum Mechanics for Dummies')
  end

  context 'criar arquivo zip' do
    it 'cria arquivo zip contendo os grãos da cesta' do
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt))

      Dir["#{Rails.root}/tmp/cesta_tempo*"].last.should == nil

      criar_arquivo_zip(@usuario.cesta)

      File.exist?(Dir["#{Rails.root}/tmp/cesta_tempo*"].last).should == true

      Zip::ZipFile.open(Dir["#{Rails.root}/tmp/cesta_tempo*"].last) { |zip_file|
        zip_file.each { |f|
          f_path=File.join("#{Rails.root}/spec/resources/downloads/", f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        }
      }

      grao_armazenado = Digest::MD5.hexdigest(File.read('./spec/resources/tabela.odt'))
      grao_extraido = Digest::MD5.hexdigest(File.read("#{Rails.root}/spec/resources/downloads/grao_quantum_mechanics_for_dummies_0.odt"))
      grao_armazenado.should == grao_extraido
      referencia_abnt = File.read("#{Rails.root}/spec/resources/downloads/referencias_ABNT.txt")
      referencia_abnt.should match "grao_quantum_mechanics_for_dummies_0.odt: #{@livro.referencia_abnt}"

      File.delete(Dir["#{Rails.root}/tmp/cesta_tempo*"].last)
    end
  end
end
