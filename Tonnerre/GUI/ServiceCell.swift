//
//  ServiceCell.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-30.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa
import Quartz

fileprivate final class PreviewItem: NSObject, QLPreviewItem {
  let previewItemTitle: String!
  let previewItemURL: URL!
  
  init(title: String, url: URL) {
    previewItemURL = url
    previewItemTitle = title
    super.init()
  }
}

final class ServiceCell: NSCollectionViewItem, CellProtocol {
  
  @IBOutlet weak var iconView: TonnerreIconView!
  @IBOutlet weak var serviceLabel: NSTextField!
  @IBOutlet weak var cmdLabel: NSTextField!
  @IBOutlet weak var introLabel: NSTextField!
  var displayItem: DisplayProtocol?
  var popoverView: NSPopover = NSPopover()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
    popoverView.contentSize = NSSize(width: 450, height: 300)
    popoverView.behavior = .transient
    popoverView.delegate = self
  }
  
  var theme: TonnerreTheme {
    get {
      return .current
    } set {
      serviceLabel.textColor = newValue.imgColour
      cmdLabel.textColor = newValue.imgColour
      introLabel.textColor = newValue.imgColour
      switch newValue {
      case .dark: iconView.shadow = nil
      case .light: iconView.shadow = {
          let shadow = NSShadow()
          shadow.shadowColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.5)
          shadow.shadowBlurRadius = 1
          shadow.shadowOffset = NSSize(width: 2, height: 3)
          return shadow
        }()
      }
    }
  }
  
  override func viewWillAppear() {
    theme = .current
  }
  
  func preview() {
    guard
      let url = (displayItem as? DisplayableContainer<URL>)?.innerItem,
      let name = (displayItem as? DisplayableContainer<URL>)?.name,
      !popoverView.isShown
    else { return }
    guard let qlView = QLPreviewView(frame: NSRect(x: 0, y: 0, width: 450, height: 600), style: .normal) else { return }
    let viewController = NSViewController()
    qlView.previewItem = PreviewItem(title: name, url: url)
    qlView.shouldCloseWithWindow = true
    viewController.view = qlView
    let cellRect = view.convert(NSRect(x: -40, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height), to: view)
    popoverView.contentViewController = viewController
    popoverView.show(relativeTo: cellRect, of: view, preferredEdge: .maxX)
  }
  
  override func pressureChange(with event: NSEvent) {
    guard event.stage == 2 && !popoverView.isShown else { return }
    preview()
  }
}

extension ServiceCell: NSPopoverDelegate {
  func popoverDidClose(_ notification: Notification) {
    popoverView.contentViewController = nil
  }
}
