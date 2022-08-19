//
//  AnimationFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 12.08.2022.
//

import UIKit
import RxFlow
import Swinject

class AnimationFlow: Flow {
  var window: UIWindow
  let container = Container()
  
  var root: Presentable {
    return self.window
  }
  
  init(window: UIWindow) {
    self.window = window
    setUpDiContainer()
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AnimationStep else { return .none }
    switch step {
    case .animationScreen:
      return openAnimationScreen()
      
    case .goToApp:
      return goToMainApp()
      
    // когда создам экран с информацией об ошибках тут будет подключено оно
    case .error:
      return .none
    }
  }
  
  private func openAnimationScreen() -> FlowContributors {
    let viewModel = AnimationViewModel(loadUseCase: container.resolve(LanguageUseCase.self)!)
    let viewController = AnimationViewController()
    viewController.viewModel = viewModel
    self.window.rootViewController = viewController
    
    return .one(flowContributor: .contribute(
      withNextPresentable: viewController,
      withNextStepper: viewModel
    ))
  }
  
  private func goToMainApp() -> FlowContributors {
    let flow = MainFlow(window: window)
    
    return .one(
      flowContributor: .contribute(
        withNextPresentable: flow,
        withNextStepper: OneStepper(withSingleStep: MainStep.goToApp)
      )
    )
  }
}
