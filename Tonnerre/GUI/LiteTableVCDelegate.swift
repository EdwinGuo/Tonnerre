//
//  LiteTableVCDelegate.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-10-19.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol LiteTableVCDelegate: class {
  /**
   A service is selected and highlighted
   - parameter service: the service pack which is selected
   */
  func serviceHighlighted(service: ServicePack?)
  /**
   Request to fill in the placeholder field with given service
   - parameter service: the service highlighted and needs to be filled in the placeholder field
   */
  func updatePlaceholder(service: ServicePack?)
  /**
   Tab key is pressed, and request for auto completion
   - parameter service: the highlighted service that needs to be completed
   */
  func tabPressed(service: ServicePack)
  /**
   Request to retrieve the last queried content
   */
  func retrieveLastQuery()
}
