//
//   UINavigationItem+Ext.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import UIKit

extension UINavigationItem {
  func setupTitle(text: String) {
    let label = UILabel()
    label.text = text
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
    
    self.titleView = label
  }
}
