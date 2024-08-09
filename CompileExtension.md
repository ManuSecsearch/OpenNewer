# OpenNewer

The OpenNewer extension is to convert skp file format between different version

## Getting Started

You'll need to get some download and developpers tools first.

### Prerequisites

#### Mac

Minimum of Xcode 7.2 with [MacOSX 10.10 sdk](https://github.com/phracker/MacOSX-SDKs).

Download the Sketchup SDK [Sketchu SDK](https://extensions.sketchup.com/sketchup-sdk).

### Build and Run

Copy the [.src/xcode](./src/xcode) folder into the samples folder where the Sketchup SDK resides

#### Mac
```
Open OpenNewer.xcodeproj
Build and Run

Note: The executable will be in your DerivedData folder for this project.
You can right-click the executable in the Targets folder to Show in Finder.
```

### Execute the program

#### Mac:
```
~/path/to/OpenNewer ~/path/to/source_sketchup_file.skp ~/path/to/destination_sketchup_converted_file version_number

Outputs a new file:
  ~/path/to/destination_sketchup_converted_file
```


