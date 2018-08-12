//
//  StoredKeys.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-20.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation
import Cocoa

enum StoredKeys: String {// Keys used in UserDefault
  case appSupportDir
  case designatedX
  case designatedY
  case defaultSearch
}

func getContext() -> NSManagedObjectContext {
  let appDelegate = NSApplication.shared.delegate as! AppDelegate
  return appDelegate.persistentContainer.viewContext
}
