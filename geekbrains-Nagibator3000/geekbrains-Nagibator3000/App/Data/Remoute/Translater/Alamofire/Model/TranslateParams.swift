//
//  TranslateParams.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import SwiftUI

public struct TranslateParams {
    let params: [String : String]
    
    init(from: String, to: String, text: String) {
        self.params = [TranslateParamsKey.from.rawValue : from,
                       TranslateParamsKey.to.rawValue : to,
                       TranslateParamsKey.text.rawValue : text]
    }
}

enum TranslateParamsKey: String {
  case from = "from"
  case to = "to"
  case text = "text"
}
