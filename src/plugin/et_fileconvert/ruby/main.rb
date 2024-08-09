require 'sketchup.rb'
require 'fileutils'

# Main code
module ET_Extensions

  module ET_FileConvert
 
    SU_VERSION = Sketchup.version.to_i
    LOGFILE = File.join(PLUGIN_DIR,'logs','log.txt')
    
    $VERBOSE = false
    # Get SketchUp version string of a saved file.
    #
    # @param path [String]
    #
    # @raise [IOError]
    #
    # @return [String]
    def self.version(path)
      v = File.binread(path, 64).tr("\x00", "")[/{([\d.]+)}/n, 1]

      v || raise(IOError, "Can't determine SU version for '#{path}'. Is file a model?")
    end

    # Ask user for path to open from.
    #
    # @return [String]
    def self.prompt_source_path
      UI.openpanel("Choisissez un fichier a convertir", "", "SketchUp Models|*.skp||")
    end

    # Ask user for path to save converted model to.
    #
    # @param source [String]
    #
    # @return [String]
    def self.prompt_target_path(source)
      # Prefixing version with 20 as SketchUp 2014 is the oldest supported
      # version. If ever supporting versions 8 or older, only prefix for
      # [20]13 and above.
      
      # With four params, it shows a drop down box for prompts that have
      # pipe-delimited lists of options. In this case, the Gender prompt
      # is a drop down instead of a text box.
      Log("Entering into prompt_target_path")
      
      prompts = ["Quelle version cible"]
      defaults = ["2017"]
      list = ["2013|2014|2015|2016|2017|2018|2019|2020|2021|2022|2023|2024"]
      choice = UI.inputbox(prompts, defaults, list, "Choix de la conversion")
      
      Log("[prompt_target_path] prompt_target_path choice #{choice}")
      if choice == false
          Log("[prompt_target_path] return nil,nil")
          return [nil,nil]
      end
      
      Log("[prompt_target_path] Now getting version")
      cible_version = choice.to_s
      ver = cible_version[4..5]
      Log("[prompt_target_path] ver: #{ver}")
      
      # title = "Save As SketchUp 20#{SU_VERSION} Compatible"
      title = "Save As #{choice} Compatible"

      directory = File.dirname(source)
      filename = "#{File.basename(source, '.skp')} SU_20#{ver}.skp"
      Log("[prompt_target_path] Prompt for a file #{source}")
      target  = UI.savepanel(title, directory, filename)
      Log("[prompt_target_path] Returning target: #{target}, ver: #{ver}")
      return ["#{target}","#{ver}"]
    end



    # Run block once a file has been created.
    #
    # @param path [String]
    # @param async [Boolean]
    # @param delay [Flaot]
    # @param block [Proc]
    #
    # @return [Void]
    def self.on_exist(path, async = true, delay = 0.2, &block)
      if File.exist?(path)
        block.call
        return
      end

      if async
        UI.start_timer(delay) { on_exist(path, async, delay, &block) }
      else
        sleep(delay)
        on_exist(path, async, delay, &block)
      end

      nil
    end

    # Convert an external model to the current SU version and open it.
    #
    # @param source [String]
    # @param target [String]
    #
    # @return [Void]
    def self.convert_and_open(source, target, ver)

      # Since the hack for running the system command without a flashing window
    # makes the call asynchronous, we need to wait to open the converted model
      # until its file exists. To check for file creation, we must first make sure
      # there is no existing file by the same name already.
      Log("[convert_and_open] convert_and_open(#{source},#{target},#{ver}")
      File.delete(target) if File.exist?(target)
      
      path = __FILE__
      path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

      binary = File.join(PLUGIN_DIR,'bin','osx','OpenNewer')
      Log("[convert_and_open] chmod executable: #{binary}")
      # Make sure it's executable before we try to run it
      File.chmod(0755, binary)
            
#      Sketchup.status_text = "Converting model to supported format..."
      cmd= "'#{binary}' '#{source}' '#{target}' #{ver}"
      
      Log("[convert_and_open] performing system(#{cmd})")
      system("#{cmd}")

      UI.messagebox("Conversion done")


      # system_call(%("#{PLUGIN_DIR}/bin/ConvertVersion" "#{source}" "#{target}" #{SU_VERSION}))
      # on_exist(target, false) { Sketchup.open_file(target) }
      Log("Leaving convert_and_open")
      nil
    end


    def self.Log(line)
      File.open("#{LOGFILE}", "a") { |f| f.write "#{line}\n" } if $VERBOSE
    end


    def self.OpenNewer
       source = prompt_source_path || return
       version = version(source).to_i
       if version <= SU_VERSION
         Sketchup.open_file(source)
         return
       end
       target,ver = prompt_target_path(source) || return
       if target != nil && ver != nil
           Log("Calling convert_and_open(#{source},#{target},#{ver}")
           convert_and_open(source, target, ver)
       end
       
       nil
    end
    
    @@loaded = false unless defined?(@@loaded)

                 
    # Create menu items (once when loading)
    unless @@loaded
    # unless file_loaded?(__FILE__)
      menu = UI.menu('File')
      menu.add_separator
      submenu = UI.menu('File').add_submenu('File Convert')
      submenu.add_item('OpenNewer') { self.OpenNewer }
      menu.add_separator
      
      file_loaded(__FILE__)
      @@loaded = true
    end

    #
    # @param clear_console [Boolean] Whether console should be cleared.
    # @param undo [Boolean] Whether last oration should be undone.
    #
    # @return [void]
    def self.reload(clear_console = true, undo = false)
      # Hide warnings for already defined constants.
      verbose = $VERBOSE
      $VERBOSE = nil
      Dir.glob(File.join(PLUGIN_ROOT, "**/*.{rb,rbe}")).each { |f| load(f) }
      $VERBOSE = verbose

      # Use a timer to make call to method itself register to console.
      # Otherwise the user cannot use up arrow to repeat command.
      UI.start_timer(0) { SKETCHUP_CONSOLE.clear } if clear_console

      Sketchup.undo if undo

      nil
    end

    

    def self.load_bin(su_vers = Sketchup.version.to_i, platform = Sketchup.platform)
      case platform
        when :platform_osx # load on osx
          case su_vers
            when 17

            when 19, 20      # non-ARM Ruby 2.5 binary
              # load
            when 21          # non-ARM Ruby 2.7 binary
              # load
            when 22, 23      # universal Ruby 2.7 binary
              # load
            when 24          # universal Ruby 3.2 binary
              # load
            else
              puts "SketchUp version #{su_vers} not supported by such and such extension."
              EXTENSION.uncheck # switch off this extension in Extension manager
          end
        when :platform_win # load on Windows
          case su_vers
            when 19, 20      # mingw64? Ruby 2.5 binary
              # load
            when 21, 22, 23  # mswin Ruby 2.7 binary
              # load
            when 24          # mswin Ruby 3.2 binary
              # load
            else
              puts "SketchUp version #{su_vers} not supported by such and such extension."
              EXTENSION.uncheck # switch off this extension in Extension manager
          end
      end
    end

  end  # module MY_ThisExtension
  
end  # module MY_Extensions
