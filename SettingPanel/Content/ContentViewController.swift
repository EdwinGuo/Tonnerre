//
//  ContentViewController.swift
//  SettingPanel
//
//  Created by Yaxin Cheng on 2018-10-25.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Cocoa

final class ContentViewController: NSViewController {
  
  var items: [[SettingItem]] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
}

extension ContentViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return items[section].count
  }
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = items[indexPath.section][indexPath.item]
    let cell = collectionView.makeItem(withIdentifier: item.displayIdentifier, for: indexPath) as! SettingCell
    item.configure(displayCell: cell)
    return cell
  }
}
