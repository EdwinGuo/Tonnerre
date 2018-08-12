//
//  ServiceResult.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-06-03.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

enum ServiceResult: DisplayProtocol {
  case service(origin: TonnerreService)
  case result(service: TonnerreService, value: DisplayProtocol)
  
  var icon: NSImage {
    switch self {
    case .service(origin: let value): return value.icon
    case .result(service: _, value: let value): return value.icon
    }
  }
  
  var name: String {
    switch self {
    case .service(origin: let value): return value.name
    case .result(service: _, value: let value): return value.name
    }
  }
  
  var content: String {
    switch self {
    case .service(origin: let value): return value.content
    case .result(service: _, value: let value): return value.content
    }
  }
  
  var placeholder: String {
    switch self {
    case .service(origin: let value): return value.placeholder
    case .result(service: _, value: let value): return value.placeholder
    }
  }
  
  init(service: TonnerreService) {
    self = .service(origin: service)
  }
  
  init(service: TonnerreService, value: DisplayProtocol) {
    self = .result(service: service, value: value)
  }
}
