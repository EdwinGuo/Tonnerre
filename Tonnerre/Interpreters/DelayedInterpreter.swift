//
//  DelayedInterpreter.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-09-13.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

final class DelayedInterpreter: InterpreterProtocol {
  typealias LoaderType = DelayedServiceLoader
  typealias TargetType = ServicePack
  
  var cachedKey: String = ""
  var cachedProviders: Array<TonnerreService> = []
  let loader = DelayedServiceLoader()
  
  func wrap(_ rawData: [TonnerreService], withTokens tokens: [String]) -> [ServicePack] {
    return rawData.map { provider in
      if tokens.count - 1 >= provider.argLowerBound && tokens.count <= provider.argUpperBound {
        return provider.prepare(input: Array(tokens[1...])).map {
          ServicePack(provider: provider, service: $0)
        }
      } else if provider.argLowerBound > 0 {
        return [ServicePack(provider: provider)]
      } else { return [] }
      }.reduce([], +)
  }
}
