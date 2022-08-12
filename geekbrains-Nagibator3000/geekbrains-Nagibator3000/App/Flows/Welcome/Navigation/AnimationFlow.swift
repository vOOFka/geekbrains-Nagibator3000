//
//  AnimationFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 12.08.2022.
//

import UIKit
import RxFlow

class AnimationFlow: Flow {
    var window: UIWindow
    
    var root: Presentable {
        return self.window
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AnimationStep else { return .none }
        switch step {
        case .animationScreen:
            return openAnimationScreen()
        }
    }
    
    private func openAnimationScreen() -> FlowContributors {
        let viewModel = AnimationViewModel()
        let viewController = AnimationViewController()
        self.window.rootViewController = viewController
        
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    
}
