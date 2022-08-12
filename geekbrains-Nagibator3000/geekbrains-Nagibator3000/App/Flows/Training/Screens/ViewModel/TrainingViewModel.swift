//
//  TrainingViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow
import RxRelay

class TrainingViewModel: Stepper {
  var steps = PublishRelay<Step>()
}

