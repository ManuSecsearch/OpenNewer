# OpenNewer

The OpenNewer extension is to convert skp file format between different version

## Getting Started

You'll need to get some download and developpers tools first.

## Prerequisites

Minimum of Xcode 7.2 with [MacOSX 10.10 sdk](https://github.com/phracker/MacOSX-SDKs).

Download the Sketchup SDK [Sketchu SDK](https://extensions.sketchup.com/sketchup-sdk).

## Build and Run

Copy the [.src/xcode](./src/xcode) folder into the samples folder where the Sketchup SDK resides

Once xcode is installed  and you copied the ```xcode``` folder in samples, you should be able to build the binary extension.

Please ensure of the right destination architecture when compiling it.

```
Open OpenNewer.xcodeproj
Build and Run

Note: The executable will be in your DerivedData folder for this project.
You can right-click the executable in the Targets folder to Show in Finder.
```

## Next build the plugin

Once you got a binary without error, you can continue to build the plugin.
You can refer to the documentation [Howtocreatetheplugin](./Howtocreatetheplugin.md) for more details




