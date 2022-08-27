//
//  TrainingStep.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow

enum TrainingStep: Step {
    case translate
    case error(ErrorType)
}
