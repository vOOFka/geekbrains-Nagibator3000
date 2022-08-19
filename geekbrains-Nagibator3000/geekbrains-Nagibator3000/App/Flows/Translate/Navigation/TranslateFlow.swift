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
    guard let step = step as? TranslateStep else { return .none }
    
    switch step {
    case .openShareRequiredScreen(let text):
        return openShareScreen(text: text)
      
    case .openLanguagesRequiredScreen(_):
      return .none
    }
  }
  
  private func openShareScreen(text: String) -> FlowContributors {
    let objectsToShare = [text]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
      viewController.present(activityVC, animated: true, completion: nil)
    
    return .none
  }
}
