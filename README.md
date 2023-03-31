Exploring the Evolution of Open Source Native iOS Applications
=======
This repository contains code, data and tools related to the "Exploring the Evolution of Open Source Native iOS Applications" M.Sc Thesis at Politecnico di Milano, A.Y. 2021/2022, by Gianluca Bergamini.

## Code
The /Code/Live Scripts folder contains four MATLAB live scripts (.mlx) explaining, step by step with code, the process to gather and analyse data from open-source applications. Code to elaborate and visualise extracted data (already available in .mat files in the /Data folder) can be run without any further measure. Code to extract data is commented-out and may be run only after complying with the instructions in the setup section of each file.

* selection.mlx contains code to extract and elaborate data about the selection of apps and commits;
* languages.mlx contains code to extract and elaborate data about the use of programming languages and versions of Swift;
* uiSpec.mlx contains code to extract and elaborate data about the choice of user interface specification methods;
* dependencyAdoption.mlx contains code to extract and elaborate data about the use of software dependencies;

The /Code/HTML contains four HTML files extracted from the corresponding MATLAB live scripts.

## Data
The /Data folder contains datasets:
* data2.mat is a MATLAB binary file containing all data gathered from the applications.
* depStats.mat is a MATLAB binary file containing the list of the most used dependencies, and the number of occurrences of each.
* projects.mat is a MATLAB binary file containing the initial list of repositories sources and names gathered from the [open-source-ios-apps](https://github.com/dkhamsing/open-source-ios-apps) repository, enriched with four boolean values for each repository indicating whether the repository contains an app, and whether the app is native, distributed and "interesting" for the study.
* projectsFiltered.mat is a MATLAB binary file containing the filtered list of applications used before the generation of data2.mat.
* apps.csv includes the URLs of repositories of the analysed apps with their reference number (ID).
* languages.csv includes the app IDs divided into the categories about the Objective-C, Swift adoption dynamics.
* swiftUI.csv includes the app IDs divided into the categories about SwiftUI adoption.

Data available in these datasets can be easily converted into NumPy arrays compatible with Python using the following code
```Python
import scipy.io
mat = scipy.io.loadmat('data2.mat', allow_pickle=True)

data = mat['data']
```

### Structure of data2.mat

data2.mat contains a cell array called "data".

Each line corresponds to an app, the columns contain the following values:
1. Repository name
2. Repository name - duplicate to check the correctness of the API data gathering procedure
3. Repository creation datetime
4. Repository last edit datetime
5. Number of stars
6. Repository source
7. Github API reference, if available
8. Repository name as owner_id/repo_id
9. Sum of Swift and Objective-C code line counts
10. Commits struct
11. Array containing the names of .xcodeproj packages
12. Optional terminal command to generate the .xcodeproj package

#### Structure of commits struct
Each app has its own commits struct, a struct array having as rows the selected commits the and as fields the following:
* tag: hash of the commit
* dateTime: timestamp of the commit
* iOSVersion: minimum supported version of iOS 
* targetedDeviceFamily: device families supported
* swiftVersion: supported version of Swift
* SwiftUIViews: struct with data about SwiftUI Views
* UIKitViewControllersSwift: struct with data about UIKit ViewControllers specified in Swift
* UIKitViewsSwift: struct with data about UIKit Views specified in Swift
* UIKitViewControllersObjC: struct with data about UIKit ViewControllers specified in Objective-C
* UIKitViewsObjC: struct with data about UIKit ViewControllers specified in Objective-C
* Storyboards: struct array with data about UIKit ViewControllers and Views in Storyboards
* XIBs: struct array with data about UIKit ViewControllers and Views in .xibs
* codeComplexity: total number of Swift and Objective-C code lines
* languagePercentagesCloc: struct with programming language info
* ObjcSwiftCloc: struct with Swift and Objective C code lines and percentages
* dependencies: struct informations about dependencies.


## Tools

### Sitrep
This repository contained a version of the [Sitrep](https://github.com/twostraws/Sitrep) tool I modified to count the number of UIKit Views and ViewControllers, as well as SwiftUI Views.

In particular, only when returning the results in JSON format, this version of Sitrep returns, in the "inheritances" array, an object for each type (UIViewController, UIView, SwiftUI.View). These objects have a "name" field corresponding to the type name, a "count" field corresponding to the total number of elements of that type and a classes object containing a list of "name":value elements, where name is the name of the specific class and value is the number of occurrencies of that specific class.

This version of Sitrep considers UIKit UIViewControllers the classes that inherit from classes whose name begins with "UI" and ends with "Controller", UIKit Views the classes that inherit from classes whose name begins with "UI" and ends with "View" and SwiftUI Views the structs that conform to the "View" protocol.

To add this functionality, I modified the Results.swift and Report.swift files located in Sources/SitrepCore.

To install the tool, it is sufficient to execute the following commands, after cloning the repository:
```bash
cd Sitrep
make install
```

The tool can then be invoked from the terminal using the command 
```bash
cd ~/path/to/a/project/
sitrep -f json
```

### CarthageAnalyzer
CarthageAnalyzer is a Swift Package providing a command-line tool I built to straightforwardly convert Carthage specification files (Cartfiles) to JSON.

To parse Cartfiles correctly, it depends on the [CarthageKit](https://github.com/Carthage/Carthage) library .

To install the tool, it is sufficient to execute the following commands, after cloning the repository:
```bash
cd CarthageAnalyzer
make install
```

The tool can then be invoked from the terminal using the command 
```bash
CarthageAnalyzer ~/path/to/a/Cartfile/file
```

CarthageAnalyzer returns, if the file is valid, a JSON array having, for each dependecy, an object having two fields named "name" and "version". 
The name field has one of the following string values, depending on the location of the dependency:

* github "github_source"
* git "git_source"
* binary "binary_source"

The version field contains a string representing the dependency version.
