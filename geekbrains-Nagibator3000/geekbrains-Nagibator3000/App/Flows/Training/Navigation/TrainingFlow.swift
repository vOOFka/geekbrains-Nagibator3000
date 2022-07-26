//
//  TrainingFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow
import UIKit
import Swinject

class TrainingFlow: Flow {
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
        guard let step = step as? TrainingStep else { return .none }
        
        switch step {
        case .error(let type):
            let flow = ErrorFlow(viewController: viewController)
            return .one(flowContributor: .contribute(
                withNextPresentable: flow,
                withNextStepper: OneStepper(withSingleStep: ErrorStep.error(type: type))
            ))
        case .translate:            
            return openTranslateScreen()
        }
    }
    
    private func openTranslateScreen() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: MainStep.goToApp)
    }
}
