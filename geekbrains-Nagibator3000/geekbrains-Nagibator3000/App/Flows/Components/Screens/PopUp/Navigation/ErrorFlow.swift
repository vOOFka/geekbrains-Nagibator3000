//
//  ErrorFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 23.08.2022.
//

import Foundation
import RxFlow
import Swinject
import UIKit

class ErrorFlow: Flow {
  var viewController: UIViewController
  var isClouseApp: Bool

  var root: Presentable {
    self.viewController
  }

  init(viewController: UIViewController, isClouseApp: Bool = false) {
    self.viewController = viewController
    self.isClouseApp = isClouseApp
  }

  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? ErrorStep else { return .none }

    switch step {
    case .error(let type):
      return navigateToError(error: type)
      
    case .close:
      return closeApp()
    }
  }

  private func navigateToError(error: ErrorType) -> FlowContributors {
    let errorVc = ErrorViewController(with: error)
    present(viewController: errorVc)

    return .one(flowContributor: .contribute(
      withNextPresentable: errorVc,
      withNextStepper: errorVc)
    )
  }
  
  private func closeApp() -> FlowContributors {
    guard isClouseApp else {
      viewController.dismiss(animated: true)
      return .none
    }

    viewController.dismiss(animated: true) {
      exit(0)
    }
    
    return .none
  }

  private func present(viewController: UIViewController ) {
    viewController.modalPresentationStyle = .overFullScreen
    viewController.modalTransitionStyle = .crossDissolve
    self.viewController.present(viewController, animated: true)
  }
}
