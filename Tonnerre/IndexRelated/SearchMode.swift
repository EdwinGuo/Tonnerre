//
//  FileSearchModes.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-20.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation
import TonnerreSearch

enum SearchMode: String {
  case `default`
  case name
  case content
  
  var indexType: TonnerreIndexType {
    switch self {
    case .content: return .metadata
    default: return .nameOnly
    }
  }
  
  var indexFileURL: URL {
    let userDefault = UserDefaults.shared
    let appSupportDir = userDefault.url(forKey: .appSupportDir)!
    let indecesFolder = appSupportDir.appendingPathComponent("Indices")
    return indecesFolder.appendingPathComponent(self.rawValue + ".tnidx")
  }
  
  /**
   Value used to identify the type in indexStorage
  */
  var storedInt: Int {
    switch self {
    case .default: return 0
    case .name: return 1
    case .content: return 2
    }
  }
  
  var targetFilePaths: [URL] {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    switch self {
    case .default:
      return [homeDir.appendingPathComponent("Applications")] + ["/System/Library/CoreServices/Finder.app", "/System/Library/CoreServices/Applications", "/System/Library/PreferencePanes", "/Applications"].map { URL(fileURLWithPath: $0) }
    default:
      let exclusions = Set(["Public", "Library", "Applications"])
      do {
        let userDirs = try FileManager.default.contentsOfDirectory(at: homeDir, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants])
        return userDirs.filter { !exclusions.contains($0.lastPathComponent) }
      } catch {
        return []
      }
    }
  }
  
  func canInclude(fileURL: URL) -> Bool {
    switch self {
    case .default:
      let allowedExtensions: Set<String> = ["app", "pref"]
      return
        allowedExtensions.contains(fileURL.pathExtension) ||
        FileTypeControl(types: .app, .systemPref).isInControl(file: fileURL)
    case .content:
      return FileTypeControl(types: .document, .message).isInControl(file: fileURL)
    case .name:
      return true
    }
  }
}

