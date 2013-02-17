require 'spec_helper'
require 'active_support/core_ext'
require 'tmpdir'
require 'docsplit'

describe Rasper::Report do
  it 'generates PDF' do
    Rasper::Compiler.compile(resource('programmers.jrxml'))

    Rasper::Report.jasper_dir = resources_dir
    pdf_content = Rasper::Report.generate('programmers', [
      { name: 'Linus', software: 'Linux' },
      { name: 'Yukihiro', software: 'Ruby' },
      { name: 'Guido', software: 'Python' } ])

    Dir.mktmpdir do |temp_dir|
      pdf_file_name = File.join(temp_dir, "output.pdf")
      File.open(pdf_file_name, 'w') {|f| f.write(pdf_content) }
      Docsplit.extract_text(pdf_file_name, ocr: false, output: temp_dir)
      output_file_name = File.join(temp_dir, "output.txt")
      content = File.read(output_file_name)
      content.lines.reject(&:blank?).map(&:chomp).should =~ \
        ["Name: Linus", "Software: Linux",
         "Name: Yukihiro", "Software: Ruby",
         "Name: Guido", "Software: Python"]
    end
  end
end