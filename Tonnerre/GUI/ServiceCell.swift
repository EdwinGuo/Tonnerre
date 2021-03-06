//
//  ServiceCell.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-30.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa
import LiteTableView

final class ServiceCell: LiteTableCell {
  
  @IBOutlet weak var iconView: TonnerreIconView!
  @IBOutlet weak var serviceLabel: NSTextField!
  @IBOutlet weak var cmdLabel: NSTextField!
  @IBOutlet weak var introLabel: NSTextField!
  var displayItem: ServicePack? = nil
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    displayItem = nil
  }
  
  override var highlightedColour: NSColor {
    if #available(OSX 10.14, *) {
      return NSColor.controlAccentColor.withAlphaComponent(0.8)
    } else {
      return super.highlightedColour.withAlphaComponent(0.8)
    }
  }
  
  func preview() {
    guard case .service(_, let service)? = displayItem else { return }
    let cellRect = view.convert(NSRect(x: -40, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height), to: view)
    PreviewPopover.shared.present(item: service, relativeTo: cellRect, of: view)
  }
}
