//
//  TonnerreField.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-29.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

final class TonnerreField: NSTextField {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    NotificationCenter.default.addObserver(forName: .windowIsHiding, object: nil, queue: .main) { [weak self] _ in
      self?.stringValue = ""
    }
  }
  
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    switch event.keyCode {
    case 18...25, 36, 49, 53, 76, 125, 126: return true
    default: return super.performKeyEquivalent(with: event)
    }
  }
  
  override func selectText(_ sender: Any?) {
    super.selectText(sender)
    currentEditor()?.selectedRange = NSRange(location: stringValue.count, length: 0)
  }

  override var mouseDownCanMoveWindow: Bool {
    return true
  }
  
  func autoComplete(cmd: String, appendingSpace: Bool) {
    let tokens = stringValue.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
    guard !tokens.isEmpty else { return }
    if tokens.count > 1 {
      let toBeCompletedString = tokens[1...].joined(separator: " ")
      let commonPart = String(zip(toBeCompletedString, cmd).map { $0.0 })
      let surplusPart = String(cmd[commonPart.endIndex...])
      stringValue = (tokens.first! + " " + commonPart + surplusPart).lowercased()
    } else {
      stringValue = cmd + (appendingSpace ? " " : "")
    }
    window?.makeFirstResponder(nil)
  }
  
  override var intrinsicContentSize: NSSize {
    let value = stringValue ?? "Tonnerre"
    let cell = NSTextFieldCell(textCell: value)
    let attributedString: NSAttributedString
    if stringValue.isEmpty {
      attributedString = NSAttributedString(string: value, attributes: [.font: NSFont.systemFont(ofSize: 35)])
    } else {
      attributedString = attributedStringValue
    }
    cell.attributedStringValue = attributedString
    let extraLength: CGFloat = 110// Used to contain the next input word when it is using pinyin
    let contentSize = NSSize(width: cell.cellSize.width + extraLength, height: cell.cellSize.height)
    return contentSize
  }
}
