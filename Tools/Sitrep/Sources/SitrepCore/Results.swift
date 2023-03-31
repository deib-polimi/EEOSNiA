//
// Results.swift
// Part of Sitrep, a tool for analyzing Swift projects.
//
// Copyright (c) 2020 Hacking with Swift
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE for license information
//

// I edited the "uiKitViewCount", "uiKitViewControllerCount", "swiftUIViewCount" computed variables to count all classes/structs that inherit, respectively, from classes whose name begins with "UI" and ends with "View", from classes whose name begins with "UI" and ends with "Controller", or conform to the "View" protocol.
// I added the uiKitViews, uiKitViewControllers, swiftUIViews dictionaries to contain the names and occurrences of each different class.

import Foundation

public struct Results {
    /// All the files detected by this scan
    var files: [File]

    /// All the classes detected across all files
    var classes = [Type]()

    /// All the structs detected across all files
    var structs = [Type]()

    /// All the enums detected across all files
    var enums = [Type]()

    /// All the protocols detected across all files
    var protocols = [Type]()

    /// All the extensions detected across all files
    var extensions = [Type]()

    /// All the imports detected across all files, stored with frequency
    var imports = NSCountedSet()

    /// A string containing all code in all files
    var totalCode = ""

    /// A string containing all stripped code in all files
    var totalStrippedCode = ""

    /// The number of lines in the longest file
    var longestFileLength = 0

    /// The File object storing the longest file that was scanned
    var longestFile: File?

    /// The nmber of lines in the longest type
    var longestTypeLength = 0

    /// The Type object storing the longest file that was scanned
    var longestType: Type?

    /// A count of how many functions were detected
    var functionCount = 0

    /// A count of how many functions were preceded by documentation comments
    var documentedFunctionCount = 0

    /// The total number of lines of code scanned across all files
    var totalLinesOfCode: Int {
        totalCode.lines.count
    }

    /// The total number of stripped lines of code scanned across all files
    var totalStrippedLinesOfCode: Int {
        totalStrippedCode.lines.count
    }

    /// How many classes inherit from UIView
    var uiKitViewCount: Int {
        classes.filter({ $0.inheritance.first != nil && $0.inheritance.first!.hasPrefix("UI") && $0.inheritance.first!.hasSuffix("View")}).map({($0.inheritance.first!)}).count
    }

    /// How many classes inherit from UIViewController
    var uiKitViewControllerCount: Int {
        classes.filter({ $0.inheritance.first != nil && $0.inheritance.first!.hasPrefix("UI") && $0.inheritance.first!.hasSuffix("Controller")}).map({($0.inheritance.first!)}).count
    }

    /// How many structs conform to View
    var swiftUIViewCount: Int {
        structs.filter({$0.inheritance.contains("View")}).map({_ in "View"}).count
    }
    
    var uiKitViews: [String: Int] {
        let filtered = classes.filter({ $0.inheritance.first != nil && $0.inheritance.first!.hasPrefix("UI") && $0.inheritance.first!.hasSuffix("View")}).map({($0.inheritance.first!)})
        
        return filtered.reduce(into: [:]) { (counts, word) in counts[word, default: 0] += 1 }
    }
    
    var uiKitViewControllers: [String: Int] {
        let filtered = classes.filter({ $0.inheritance.first != nil && $0.inheritance.first!.hasPrefix("UI") && $0.inheritance.first!.hasSuffix("Controller")}).map({($0.inheritance.first!)})
        
        return filtered.reduce(into: [:]) { (counts, word) in counts[word, default: 0] += 1 }
    }
    
    var swiftUIViews: [String: Int] {
        let views = structs.filter({$0.inheritance.contains("View")}).map({_ in "View"})
        return views.reduce(into: [:]) { (counts, word) in counts[word, default: 0] += 1 }
    }
}
