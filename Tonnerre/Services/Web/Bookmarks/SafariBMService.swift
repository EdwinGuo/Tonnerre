//
//  SafariBMService.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-07-19.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

struct SafariBMService: BookMarkService {
  static let browser: Browser = .safari
  let name: String = "Safari BookMarks"
  let content: String = "Quick launch Safari Bookmarks"
  let keyword: String = "safari"
  let defered: Bool = true
  
  func parseFile() throws -> [BookMarkService.BookMark] {
    guard let bookmarkFile = type(of: self).browser.bookMarksFile else { return [] }
    let bookmarkData = try Data(contentsOf: bookmarkFile)
    let plistObject = try PropertyListSerialization.propertyList(from: bookmarkData, options: .mutableContainersAndLeaves, format: nil)
    guard let plist = plistObject as? Dictionary<String, Any> else { return [] }
    return parse(plist: plist)
  }
  
  private func parse(plist: Dictionary<String, Any>) -> [BookMarkService.BookMark] {
    if (plist["WebBookmarkType"] as? String) == "WebBookmarkTypeList" {
      guard let children = plist["Children"] as? [Dictionary<String, Any>] else { return [] }
      return children.map { parse(plist: $0) }.reduce([], +)
    } else if (plist["WebBookmarkType"] as? String) == "WebBookmarkTypeLeaf" {
      guard
        let URLString = plist["URLString"] as? String,
        let url = URL(string: URLString),
        let title = (plist["URIDictionary"] as? Dictionary<String, String>)?["title"]
      else { return [] }
      return [(title, url)]
    } else { return [] }
  }
}
