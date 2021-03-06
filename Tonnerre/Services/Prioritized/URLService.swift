//
//  URLService.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-06-06.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

struct URLService: BuiltInProvider {
  let keyword: String = ""
  let argLowerBound: Int = 1
  let icon: NSImage = .safari
  let content: String = "Open typed URL in a browser"
  private let urlRegex = try! NSRegularExpression(pattern: "^(https?:\\/\\/)?(\\w+\\.)+[a-z]{2,5}(\\/[a-z0-9?\\-=_&/.]*)*", options: .caseInsensitive)
  
  func prepare(withInput input: [String]) -> [DisplayProtocol] {
    guard let query = input.first, input.count == 1 else { return [] }
    let isURL = query.starts(with: "http://") ||
      query.starts(with: "https://") ||
      urlRegex.numberOfMatches(in: query, options: .anchored, range: NSRange(location: 0, length: query.count)) == 1
    guard isURL else { return [] }
    let url: URL
    if query.starts(with: "http") { url = URL(string: query)! }
    else { url = URL(string: "https://\(query)")! }
    let browsers: [Browser] = [.safari, .chrome]
        .filter { $0.appURL != nil }
        .sorted { LaunchOrder.retrieveTime(with: $0.name) > LaunchOrder.retrieveTime(with: $1.name) }
    return browsers.map { DisplayableContainer(name: url.absoluteString, content: "Open URL in \($0.name)", icon: $0.icon!, innerItem: url, extraContent: $0) }
  }
  
  func serve(service: DisplayProtocol, withCmd: Bool) {
    guard
      let service = service as? DisplayableContainer<URL>,
      let request = service.innerItem,
      let browser = service.extraContent as? Browser,
      let browserURL = browser.appURL
    else { return }
    LaunchOrder.save(with: browser.name)
    do {
      _ = try NSWorkspace.shared.open([request], withApplicationAt: browserURL, options: .default, configuration: [:])
    } catch {
      #if DEBUG
      print("URL Service Error:", error)
      #endif
    }
  }
}
