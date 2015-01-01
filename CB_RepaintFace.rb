# Register and Load TF Extensions
require 'sketchup.rb'
require 'extensions.rb'
base_name = "CB_RepaintFace"
require "#{base_name}/version.rb"
cb_extension = SketchupExtension.new "Repaint Face", "CB_RepaintFace/repaint_face.rb"
cb_extension.version = CB_PluginInfo.const_get("#{base_name}_VERSION")
cb_extension.description = "Quickly change the color of a face, even if it's nested inside a component."
cb_extension.copyright = "Copyright (c) 2014, Clark Bremer"
cb_extension.creator = "Clark Bremer"
Sketchup.register_extension cb_extension, true