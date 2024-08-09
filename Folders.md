# Organization of folders

The plugin is written into Ruby and rely over a SDK Sketchup Extension.

## Folders 

You'll find mainly two folder, one for the plugin and one for the xcode c extension 

### xcode folder

This folder contains the xcode project file and the C source code the extension.
In order to build the extension please refer to the file [CompileExtension](./CompileExtension.md)
Inside src folder, you will find two folders 

### plugin folder

This folder contains the ruby source code of the plugin i.e. the loader and the module corresponding as a folder with the same name.

Then inside you'll find a 'bin' folder hierarchy to keep the hierarcht and where should be place the compiled extension 

In order to build the plugin, you'll have first to compile the extension and then refer to the file [Howtocreatetheplugin](./Howtocreatetheplugin.md) to build the final plugin

### et_fileconvert/bin/osx 

This is the folder where you should put your binary file actually.
Once it has been built with xcode you can copy it here in this folder

