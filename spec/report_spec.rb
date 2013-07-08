require 'spec_helper'
require 'active_support/core_ext'
require 'tmpdir'
require 'docsplit'

java_import Java::java::util::Locale

describe Rasper::Report do
  before(:each) { Rasper::Compiler.compile(resource('programmers.jrxml'))}

  it 'generates PDF' do
    pdf_content = Rasper::Report.generate('programmers', [
      { name: 'Linus', software: 'Linux' },
      { name: 'Yukihiro', software: 'Ruby' },
      { name: 'Guido', software: 'Python' } ],
      { 'CITY' => 'Campos dos Goytacazes, Rio de Janeiro, Brazil',
        'DATE' => '02/01/2013' })

    Dir.mktmpdir do |temp_dir|
      pdf_file_name = File.join(temp_dir, "output.pdf")
      File.open(pdf_file_name, 'w') {|f| f.write(pdf_content) }
      Docsplit.extract_text(pdf_file_name, ocr: false, output: temp_dir)
      output_file_name = File.join(temp_dir, "output.txt")
      content = File.read(output_file_name)
      content.lines.reject(&:blank?).map(&:chomp).should =~ \
        ["Campos dos Goytacazes, Rio de Janeiro, Brazil, 02/01/2013",
         "Name: Linus", "Software: Linux",
         "Name: Yukihiro", "Software: Ruby",
         "\fName: Guido", "Software: Python"]
    end
  end

  context 'locales' do
    before(:each) do
      Locale.set_default(original_locale)
      Rasper::Config.configure {|c| c.locale = 'pt_BR' }
    end

    let(:original_locale) { Locale.new('es', 'AR') }

    it 'sets configured locale' do
      Locale.stub(:new).with('pt', 'BR').and_return(:br_locale)
      Locale.stub(:get_default).and_return(original_locale)
      Locale.should_receive(:set_default).with(:br_locale) do
        Locale.should_receive(:set_default).with(original_locale)
      end

      Rasper::Report.generate('programmers', [
        { name: 'Linus', software: 'Linux' }],
        { 'CITY' => 'A', 'DATE' => 'B' })
    end

    it 'restores default locale' do
      Rasper::Report.generate('programmers', [
        { name: 'Linus', software: 'Linux' }],
        { 'CITY' => 'A', 'DATE' => 'B' })

      Locale.get_default.should == original_locale
    end
  end
end