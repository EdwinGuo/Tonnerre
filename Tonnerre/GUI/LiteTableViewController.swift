//
//  LiteTableViewController.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-10-18.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

class LiteTableViewController: NSViewController {
  
  var datasource: [ServicePack] = [] {
    didSet {
      HeightConstraint.constant = CellHeight * CGFloat(min(9, datasource.count))
      highlightedIndex = -1
      tableView.reload()
      if case .service(_, _)? = datasource.first {
        delegate?.serviceHighlighted(service: datasource.first)
      } else {
        delegate?.serviceHighlighted(service: nil)
      }
      delegate?.updatePlaceholder(service: datasource.first)
    }
  }
  var tableView: LiteTableView {
    return view as! LiteTableView
  }
  private var highlightedIndex = -1
  weak var delegate: LiteTableVCDelegate?
  
  let CellHeight: CGFloat = 56
  private var HeightConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
    HeightConstraint = view.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([HeightConstraint])
    
    tableView.liteDelegate   = self
    tableView.liteDataSource = self
    tableView.register(nib: NSNib(nibNamed: "ServiceCell", bundle: .main)!, withIdentifier: .ServiceCell)
    let allowedKeys: [UInt16] = [48, 36, 76]
    tableView.allowedKeyCodes.formUnion(allowedKeys)
  }
  
  private var modifierMonitor: Any?
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    modifierMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] in
      self?.modifierChanged($0)
      return $0
    }
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    
    if let monitor = modifierMonitor {
      NSEvent.removeMonitor(monitor)
      modifierMonitor = nil
    }
  }
  
  func modifierChanged(_ event: NSEvent) {
    guard highlightedIndex >= 0, highlightedIndex < datasource.count else { return }
    let source = datasource[highlightedIndex]
    let highlightedCell = tableView.highlightedCell as? ServiceCell
    if event.modifierFlags.contains(.command) {
      highlightedCell?.introLabel.stringValue = source.alterContent ?? source.content
      highlightedCell?.iconView.image = source.alterIcon ?? source.icon
    } else if event.modifierFlags.contains(.init(rawValue: 256)) {// Released key
      highlightedCell?.introLabel.stringValue = source.content
      highlightedCell?.iconView.image = source.icon
    }
  }
  
  func retrieveHighlighted() -> ServicePack? {
    guard datasource.count > 0 else { return nil }
    return datasource[max(0, highlightedIndex)]
  }
}

extension LiteTableViewController: LiteTableDelegate, LiteTableDataSource {
  func viewDidScroll(_ tableView: LiteTableView) {
    for (index, cell) in tableView.visibleCells.enumerated() {
      (cell as? ServiceCell)?.cmdLabel.stringValue = "⌘\(index + 1)"
    }
  }
  
  func keyPressed(_ event: NSEvent) {
    switch event.keyCode {
    case 125, 126: // move down/up
      if datasource.count == 0 && event.keyCode == 126 {
        delegate?.retrieveLastQuery()
      }
      guard datasource.count > 0 else { return }
      highlightedIndex += event.keyCode == 125 ? 1 : -1
      let selectedService = datasource[max(highlightedIndex, 0)]
      delegate?.serviceHighlighted(service: selectedService)
      delegate?.updatePlaceholder(service: selectedService)
    case 48: // tab
      let selectedService = datasource[max(highlightedIndex, 0)]
      delegate?.tabPressed(service: selectedService)
    case 36, 76: // enter
      guard event.modifierFlags.contains(.command), let servicePack = retrieveHighlighted() else { break }
      delegate?.serve(servicePack, withCmd: true)
    default:
      break
    }
  }
  
  func cellReuseThreshold(_ tableView: LiteTableView) -> Int {
    return 9
  }
  
  func numberOfCells(_ tableView: LiteTableView) -> Int {
    return datasource.count
  }
  
  func cellHeight(_ tableView: LiteTableView) -> CGFloat {
    return CellHeight
  }
  
  func prepareCell(_ tableView: LiteTableView, at index: Int) -> LiteTableCell {
    let cell = tableView.dequeueCell(withIdentifier: .ServiceCell) as! ServiceCell
    let data = datasource[index]
    cell.iconView.image = data.icon
    cell.serviceLabel.stringValue = data.name
    cell.introLabel.stringValue = data.content
    cell.cmdLabel.stringValue = "⌘\(index % 9 + 1)"
    return cell
  }
}
