//
//  PrioriLoader.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-09-13.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

final class PrioriLoader: ServiceLoader {
  typealias ServiceType = TonnerreService
  private let providers: [TonnerreService]
  var cachedKey: String = ""
  var cachedProviders: Array<TonnerreService> = []
  
  func _find(keyword: String) -> [TonnerreService] {
    return providers
  }
  
  init() {
    providers  = [LaunchService(), CalculationService(), URLService(), CurrencyService(), FlightService()]
    let saveToSettings: (ArraySlice<TonnerreService>) -> () = { providers in
      DispatchQueue.global(qos: .background).async {
        let userDefault = UserDefaults.shared
        let settings = providers.map { [type(of: $0).keyword, $0.name, $0.content, type(of: $0).settingKey] }
        userDefault.set(settings, forKey: .prioriProviders)
      }
    }
    saveToSettings(providers[1...])
  }
}
