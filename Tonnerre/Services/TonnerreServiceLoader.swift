//
//  TonnerreServiceLoader.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-05-30.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

struct TonnerreServiceLoader {
  /**
   A trie that contains all normal services (initialized after selection)
  */
  private let normalServiceTrie: Trie<TonnerreService.Type>
  /**
   A trie that contains all system services (initialized after selection)
   */
  private let systemServiceTrie: Trie<TonnerreService.Type>
  /**
   Prioritized services are loaded anyway, and they react user queries as input for `prepare(input:)`
  */
  private let prioritizedServices: [TonnerreService]
  /**
   Extended services are loaded from tne files or json files
   */
  private let extensionServices: [TonnerreService]
  
  /**
   Indicates the service is normal or system
  */
  enum serviceType {
    /**
     Services that behave normal
    */
    case normal
    /**
     Services that may modify system preferences, and has no autoCompletion
    */
    case system
  }
  
  /**
   load services based on the input key and specified type
   - parameter keyword: the keyword user typed in the TonnerreField (first word). All services is located based on their keywords
   - parameter type: the type of service to load
  */
  func load(keyword: String, type: serviceType = .normal) -> [TonnerreService] {
    if keyword.starts(with: "@") { return [ReloadService.init()] }// @ is a special modifier only for reload
    if type == .normal {
      let fetchedServices = normalServiceTrie.find(value: keyword)
        .filter { !$0.isDisabled }
        .map { $0.init() }
      return fetchedServices + extensionServices + prioritizedServices
    } else if type == .system {
      return systemServiceTrie.find(value: keyword).filter { !$0.isDisabled } .map { $0.init() }
    } else { return [] }
  }
  
  init() {
    prioritizedServices = [LaunchService(), CalculationService(), URLService(), CurrencyService()]
    extensionServices = [DynamicService(), DynamicWebService()]
    let normalServices: [TonnerreService.Type] = [FileNameSearchService.self, FileContentSearchService.self, GoogleSearch.self, AmazonSearch.self, WikipediaSearch.self, GoogleImageSearch.self, YoutubeSearch.self, GoogleMapService.self, TrashEmptyService.self, DictionarySerivce.self, GoogleTranslateService.self, BingSearch.self, DuckDuckGoSearch.self, LockService.self, ScreenSaverService.self, SafariBMService.self, ChromeBMService.self, TerminalService.self]
    let systemServices: [TonnerreService.Type] = [ApplicationService.self, VolumeService.self, ClipboardService.self]
    
    normalServiceTrie = Trie(values: normalServices) { $0.keyword }
    systemServiceTrie = Trie(values: systemServices) { $0.keyword }
    if ClipboardService.isDisabled == false {
      ClipboardService.monitor.start()
    }
    saveToPlist(services: normalServices, side: "left")
    saveToPlist(services: systemServices + [CalculationService.self, CurrencyService.self], side: "right")
  }
  
  private func saveToPlist(services: [TonnerreService.Type], side: String) {
    let userDefault = UserDefaults(suiteName: "Tonnerre")!
    let settingStoreKey = "tonnerre.settings"
    var settingsDict: SettingDict
    if let existingDict = userDefault.dictionary(forKey: settingStoreKey), !existingDict.isEmpty {
      settingsDict = existingDict as! SettingDict
    } else {
      let settingURL = Bundle.main.url(forResource: "Settings", withExtension: "plist")!
      let plistFile = Plist(fileURL: settingURL)
      settingsDict = plistFile.read()! as! SettingDict
    }
    for service in services {
      let object = service.init()
      settingsDict["secondTab"]![side]![service.settingKey] =
        ["title":  object.name, "detail": object.content, "type": "gradient"]
    }
    userDefault.set(settingsDict, forKey: "tonnerre.settings")
  }
  
  /**
   Reload the dynamic services from file systems
  */
  func reload() {
    extensionServices.compactMap { $0 as? DynamicProtocol }.forEach { $0.reload() }
  }
}
