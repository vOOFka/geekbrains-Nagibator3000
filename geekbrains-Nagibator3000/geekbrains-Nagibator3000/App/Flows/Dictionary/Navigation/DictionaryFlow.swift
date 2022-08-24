//
//  DictionaryFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
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

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? DictionaryStep else { return .none }

    switch step {
    case .error(let type):
      let flow = ErrorFlow(viewController: viewController)
      return .one(flowContributor: .contribute(
        withNextPresentable: flow,
        withNextStepper: OneStepper(withSingleStep: ErrorStep.error(type: type))
      ))
    case .translate:
        return openTranslateScreen()!
    }
  }
    
    private func openTranslateScreen() -> FlowContributors? {
        if let tabBarViewControllers = self.viewController.tabBarController?.viewControllers,
           let translateViewController = tabBarViewControllers.compactMap({ $0 as? TranslateViewController }).first,
           let viewModel = translateViewController.viewModel {
               self.viewController.present(translateViewController, animated: true, completion: nil)
               
               return .one(flowContributor: .contribute(
                withNextPresentable: translateViewController, withNextStepper: viewModel)
               )
           }
        return nil
    }
}
