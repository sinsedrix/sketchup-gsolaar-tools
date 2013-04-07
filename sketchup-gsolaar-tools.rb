# Loader for sketch-up-gsolaar-tools

require 'sketchup.rb'
require 'extensions.rb'
require 'rexml/document'

as_gsolaar = SketchupExtension.new "GSolaar Importer", "sinse_plugins/ruby/gsolaar_importer.rb"
as_gsolaar.copyright= 'Copyright 2013 Cédric Couliou'
as_gsolaar.creator= 'Cédric Couliou, sinsedrix.com'
as_gsolaar.version = '0.1'
as_gsolaar.description = "A plugin to import GSolaar polyhedra to the current model."
Sketchup.register_extension as_gsolaar, true
