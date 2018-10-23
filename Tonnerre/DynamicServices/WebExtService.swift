//
//  WebExtService.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-09-05.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

/**
 Wrapper class for WebExts
*/
final class WebExtService: TonnerreService {
  static let keyword: String = ""
  let argLowerBound: Int = 0
  let argUpperBound: Int = .max
  let icon: NSImage = #imageLiteral(resourceName: "tonnerre_extension")
  
  @available(*, deprecated: 6.0, message: "Prepare is replaced by functions in WebExtInterpreter")
  func prepare(input: [String]) -> [DisplayProtocol] {
    fatalError("Prepare is replaced by functions in WebExtInterpreter")
  }
  
  func serve(source: DisplayProtocol, withCmd: Bool) {
    guard
      let webExt = source as? WebExt,
      let url = URL(string: webExt.rawURL)
    else { return }
    let workspace = NSWorkspace.shared
    workspace.open(url)
  }
}
