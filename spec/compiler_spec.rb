require 'spec_helper'

describe Rasper::Compiler do
  it 'compiles from JRXML' do
    begin
      Rasper::Compiler.compile(resource('programmers.jrxml'))
      # merely ensures jasper file was created
      File.should be_exists(resource('programmers.jasper'))
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
      Locale.stub(:new).with('pt', 'BR').and_return(:br_locale)
      Locale.stub(:get_default).and_return(original_locale)
      Locale.should_receive(:set_default).with(:br_locale) do
        Locale.should_receive(:set_default).with(original_locale)
      end
      compile!
    end

    it 'restores default locale' do
      compile!
      Locale.get_default.should == original_locale
    end
  end
end