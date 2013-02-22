Rasper
======

JRuby client to JasperReports API.

Currently, only does compilation of JRXML files and generation of PDF reports.


Installation
------------

After installing the gem::

    gem install rasper

You should install `Apache Maven 2 <http://maven.apache.org>`_ in order to
download the JAR files needed to run JasperReports. This done, run a command
for generating ``pom.xml``::

    rasper generate_pom

and run Maven to download all dependencies::

    mvn dependency:copy-dependencies -DoutputDirectory=/dir/for/jars

where ``/dir/for/jars`` is the directory in which JARs will be downloaded.

For running tests, JAR files should be stored in ``java/jars`` directory.


Usage
-----

Before doing anything, you should configure Rasper::

    Rasper::Config.configure do |config|
      config.jar_dir = "/dir/of/jars"
      config.jasper_dir = "/dir/of/compiled/reports"
      config.image_dir = "/dir/of/images"
    end


To compile a JRXML file, just run::

    Rasper::Compiler.compile("path-to-jrxml-file", "output-directory")

and Rasper will compile JRXML file and generate a ``jasper`` file. The second
argument is optional and, if provided, should point to directory in which you
want jasper file be stored. If it is omitted, jasper file is stored at the same
directory as JRXML file.


Having a compiled jasper file, you can generate a PDF report::


    pdf_content = Rasper::Report.generate('programmers', [
      { name: 'Linus', software: 'Linux' },
      { name: 'Yukihiro', software: 'Ruby' },
      { name: 'Guido', software: 'Python' } ],
      { 'CITY' => 'Campos dos Goytacazes, Rio de Janeiro, Brazil',
        'DATE' => '02/01/2013' })


In example above, jasper directory and image directory (if there's some)
should be configured.

``Rasper::Report.generate`` returns an array containing PDF bytes. It takes
the jasper file name, an array of hashes having the fields and values for the
report, and an optional third hash argument containing the report parameters.
All the hash keys should match the fields and parameter names within the JRXML
report.


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
