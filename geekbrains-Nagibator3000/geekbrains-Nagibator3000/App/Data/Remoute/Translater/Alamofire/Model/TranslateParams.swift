//
//  TranslateParams.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import SwiftUI

public struct TranslateParams {
  let params: [String: String]
}

enum TranslateParamsKey: String {
  case from
  case to
  case text
}
