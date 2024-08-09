require 'sketchup.rb'
require 'extensions.rb'


module ET_Extensions

  module ET_FileConvert

    # Plugin ID and dir
    _file_ = __FILE__
    _file_.force_encoding("UTF-8") if _file_.respond_to?(:force_encoding)

    PLUGIN_ID = File.basename(_file_, ".*")
    PLUGIN_DIR = File.join(File.dirname(_file_), PLUGIN_ID)
      
    my_extension_loader = SketchupExtension.new('File Convert', File.join(PLUGIN_DIR, 'ruby', 'main'))
    # Load extension
    my_extension_loader.copyright = 'Copyright 2024 by Manu'
    my_extension_loader.creator = 'Manu'
    my_extension_loader.version = '1.2.0'
    my_extension_loader.description = 'Objective is to convert file into 2014.'
    Sketchup.register_extension( my_extension_loader, true )

  end  # module MY_ThisExtension
  
end  # module MY_Extensions
