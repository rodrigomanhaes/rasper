require 'spec_helper'

describe Rasper::Compiler do
  it 'compiles from JRXML' do
    begin
      Rasper::Compiler.compile(resource('programmers.jrxml'))
      # merely ensures jasper file was created
      expect(File).to be_exists(resource('programmers.jasper'))
    ensure
      File.unlink(resource("programmers.jasper")) rescue nil
    end
  end

  context 'locales' do
    before(:each) do
      Locale.set_default(original_locale)
      Rasper::Config.configure {|c| c.locale = 'pt_BR' }
    end

    def compile!
      Rasper::Compiler.compile(resource('programmers.jrxml'))
    ensure
      File.unlink(resource("programmers.jasper")) rescue nil
    end

    let(:original_locale) { Locale.new('es', 'AR') }

    it 'sets configured locale' do
      allow(Locale).to receive(:new).with('pt', 'BR').and_return(:br_locale)
      allow(Locale).to receive(:get_default).and_return(original_locale)
      expect(Locale).to receive(:set_default).with(:br_locale) do
        expect(Locale).to receive(:set_default).with(original_locale)
      end
      compile!
    end

    it 'restores default locale' do
      compile!
      expect(Locale.get_default).to eq original_locale
    end
  end
end
