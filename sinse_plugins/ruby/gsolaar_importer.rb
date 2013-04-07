=begin
Copyright 2013, Cedric COULIOU
All Rights Reserved

THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
FITNESS FOR A PARTICULAR PURPOSE.

License:        CeCILL (http://www.cecill.info/licences.fr.html)

Author :        Cedric COULIOU, sinsedrix.com, sinsedrix@gmail.com
Website:        http://gsolaar.sourceforge.net/

Name :          GSolaar Importer
Version:        0.1
Date :          01/04/2013

Description :   This plugin imports GSolaar poyhedra to the currently open model

Usage :         File > Import... > GSolaar files (*.saa)

=end

class GSolaarImporter < Sketchup::Importer

	# This method is called by SketchUp to determine the description that
	# appears in the File > Import dialog's pulldown list of valid
	# importers. 
	def description
		return "GSolaar files (*.saa)"
	end

	# This method is called by SketchUp to determine what file extension
	# is associated with your importer.
	def file_extension
		return "saa"
	end

	# This method is called by SketchUp to get a unique importer id.
	def id
		return "com.sketchup.importers.gsolaar_saa"
	end

	# This method is called by SketchUp to determine if the "Options"
	# button inside the File > Import dialog should be enabled while your
	# importer is selected.
	def supports_options?
		return true
	end

	# This method is called by SketchUp when the user clicks on the
	# "Options" button inside the File > Import dialog. You can use it to
	# gather and store settings for your importer.
	def do_options
		# In a real use you would probably store this information in an
		# instance variable.
		prompts = ['Scale:']
		defaults = ['10']
		my_settings = UI.inputbox(prompts, defaults, "Import Options")
	end

	# This method is called by SketchUp after the user has selected a file
	# to import. This is where you do the real work of opening and
	# processing the file.
	def load_file(file_path, status)
		saa_file = File.new(file_path)
		saa_doc = REXML::Document.new saa_file
		
		model = Sketchup.active_model
		entities = model.entities
		edges = {}
		vertices = {}
		scale = 10
		name = saa_doc.elements["saa/solid"].attributes["name"]
		
		model.start_operation name

		t = Geom::Transformation.scaling scale
		
		puts "Importing '"+ name +"' from "+ file_path
		
		puts "Importing vertices..."
		saa_doc.elements.each("//vertices/vertex") { |v| 
			vertices[v.attributes["id"]] = t * Geom::Point3d.new(v.attributes["x"].to_f, v.attributes["y"].to_f, v.attributes["z"].to_f)
		}
		
		puts "Importing edges..."
		saa_doc.elements.each("//edges/edge") { |e| 
			edges[e.attributes["id"]] = entities.add_line(vertices[e.attributes["v1"]], vertices[e.attributes["v2"]])
		}
		
		puts "Importing wings..."
		saa_doc.elements.each("//wings/wing") { |w| 
			entities.add_face w.attributes["edge-list"].split.map { |eid| edges[eid] }
		}


		model.commit_operation
		return 0 # 0 is the code for a successful import
	end
end

Sketchup.register_importer(GSolaarImporter.new)
