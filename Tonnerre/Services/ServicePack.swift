//
//  ServiceResult.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-06-03.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

/**
 Service pack is a data structure represents a service provider or a service bounded with its provider
*/
enum ServicePack: DisplayProtocol {
  /**
   The provider type
  */
  case provider(ServiceProvider)
  /**
   The service type, with its specific provider
  */
  case service(provider: ServiceProvider, content: DisplayProtocol)
  
  var icon: NSImage {
    switch self {
    case .provider(let provider): return provider.icon
    case .service(provider: _, content: let value): return value.icon
    }
  }
  
  var name: String {
    switch self {
    case .provider(let provider): return provider.name
    case .service(provider: _, content: let value): return value.name
    }
  }
  
  var content: String {
    switch self {
    case .provider(let provider): return provider.content
    case .service(provider: _, content: let value): return value.content
    }
  }
  
  var placeholder: String {
    switch self {
    case .provider(let provider): return provider.placeholder
    case .service(provider: _, content: let value): return value.placeholder
    }
  }
  
  var alterContent: String? {
    switch self {
    case .provider(let provider): return provider.alterContent
    case .service(provider: let provider, content: let value): return value.alterContent ?? provider.alterContent
    }
  }
  
  var alterIcon: NSImage? {
    switch self {
    case .provider(let provider): return provider.alterIcon
    case .service(provider: let provider, content: let value): return value.alterIcon ?? provider.alterIcon
    }
  }
  
  var provider: ServiceProvider {
    switch self {
    case .provider(let provider): return provider
    case .service(provider: let provider, content: _): return provider
    }
  }
  
  /**
   Constructor of ServicePack
   - parameter provider: the service provider needs to be represented
  */
  init(provider: ServiceProvider) {
    self = .provider(provider)
  }
  
  /**
   Constructor of ServicePack
   - parameter provider: the service provider needs to be represented
   - parameter service: the service generated by the provider
  */
  init(provider: ServiceProvider, service: DisplayProtocol) {
    self = .service(provider: provider, content: service)
  }
}

extension ServicePack: Hashable {
  static func == (lhs: ServicePack, rhs: ServicePack) -> Bool {
    switch (lhs, rhs) {
    case (.provider(let lp), .provider(let rp)):
      return lp.id == rp.id
    case (.service(provider: let lp, content: let lc),
          .service(provider: let rp, content: let rc)):
      return (lp.id == rp.id) && (lc.name == rc.name) &&
        (lc.content == rc.content)
    default:
      return false
    }
  }
  
  func hash(into hasher: inout Hasher) {
    switch self {
    case .provider(let provider):
      hasher.combine(provider.id)
    case .service(provider: let provider, content: let service):
      hasher.combine(provider.id)
      hasher.combine(service.name)
      hasher.combine(service.content)
    }
  }
}
