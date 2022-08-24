//
//  TranslateFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow
import UIKit
import Swinject

class TranslateFlow: Flow {
  var viewController: UIViewController
  let container: Container!

  var root: Presentable {
    self.viewController
  }

  init(
    viewController: UIViewController,
    container: Container
  ) {
    self.viewController = viewController
    self.container = container
  }

  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? TranslateStep else { return .none }
    
    switch step {
    case .openShareRequiredScreen(let text):
        return openShareScreen(text: text)
      
    case .openLanguagesRequiredScreen(let language):
      return openLenguagesScreen(language: language)
      
    case .selectedLanguage(let language):
      return updateLanguage(language: language)
      
    case .error(let type):
      let flow = ErrorFlow(viewController: viewController)
      return .one(flowContributor: .contribute(
        withNextPresentable: flow,
        withNextStepper: OneStepper(withSingleStep: ErrorStep.error(type: type))
      ))
    }
  }
  
  private func openShareScreen(text: String) -> FlowContributors {
    let objectsToShare = [text]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
      viewController.present(activityVC, animated: true, completion: nil)
    
    return .none
  }
  
  private func openLenguagesScreen(language: LanguageModel) -> FlowContributors {
    let viewModel = SelectLanguageViewModel(
      carrentLanguages: language,
      languagesUseCase: container.resolve(LanguageUseCase.self)!
    )
    
    let viewController = SelectLanguageViewController()
    viewController.viewModel = viewModel
    self.viewController.present(viewController, animated: true, completion: nil)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: viewController, withNextStepper: viewModel)
    )
  }
  
  private func updateLanguage(language: LanguageModel) -> FlowContributors {
    let viewController = self.viewController.presentedViewController
    viewController?.dismiss(animated: true)
    
    guard let traslateVc = self.viewController as? TranslateViewController else { return .none }
    
    traslateVc.viewModel.input.onLanguageUpdated.accept(language)
    return .none
  }
}
