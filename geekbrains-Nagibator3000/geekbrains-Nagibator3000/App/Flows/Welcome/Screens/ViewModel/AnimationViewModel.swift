//
//  AnimationViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 12.08.2022.
//

import UIKit
import RxFlow
import RxCocoa

class AnimationViewModel: Stepper {
    var steps = PublishRelay<Step>()
}
