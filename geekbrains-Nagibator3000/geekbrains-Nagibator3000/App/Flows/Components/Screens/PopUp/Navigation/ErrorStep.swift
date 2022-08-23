//
//  ErrorStep.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 23.08.2022.
//

import Foundation

import Foundation
import RxFlow

enum ErrorStep: Step {
  case error(type: ErrorType)
}
