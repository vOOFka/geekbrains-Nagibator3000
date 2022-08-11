//
//  DictionaryFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 11.08.2022.
//

import Foundation
import RxFlow
import UIKit
import Swinject

class DictionaryFlow: Flow {
  var viewController: UIViewController
  private let container = Container()

  var root: Presentable {
    self.viewController
  }

  init(
    viewController: UIViewController
  ) {
    self.viewController = viewController
  }

  func navigate(to step: Step) -> FlowContributors {
    .none
  }
}
