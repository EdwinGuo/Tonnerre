//
//  ClipboardMonitor.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-07-05.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

class ClipboardMonitor {
  private let pasteboard: NSPasteboard
  private var changedCount: Int
  private let `repeat`: Bool
  private let interval: TimeInterval
  private let callback: (String, NSPasteboard.PasteboardType)->Void
  private var timer: Timer?
  
  init(interval: TimeInterval, repeat: Bool = true, callback: @escaping (String, NSPasteboard.PasteboardType)->Void) {
    pasteboard = NSPasteboard.general
    changedCount = pasteboard.changeCount
    self.`repeat` = `repeat`
    self.interval = interval
    self.callback = callback
  }
  
  func start() {
    timer = Timer(timeInterval: interval, repeats: `repeat`) { [weak self] _ in
      guard
        let changedCount = self?.pasteboard.changeCount,
        let originCount = self?.changedCount,
        originCount != changedCount
      else { return }
      if let fileURL = self?.pasteboard.string(forType: .fileURL) {
        self?.callback(fileURL, .fileURL)
      } else if let string = self?.pasteboard.string(forType: .string) {
        self?.callback(string, .string)
      }
      self?.changedCount = changedCount
    }
    timer?.fire()
  }
  
  func stop() {
    timer?.invalidate()
  }
}