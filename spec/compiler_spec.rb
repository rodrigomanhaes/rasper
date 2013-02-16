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
end