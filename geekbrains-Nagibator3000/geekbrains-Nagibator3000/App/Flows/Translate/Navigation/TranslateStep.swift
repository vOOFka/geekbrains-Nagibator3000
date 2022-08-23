//
//  TranslateStep.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow

enum TranslateStep: Step {
  case openLanguagesRequiredScreen(language: LanguageModel)
  case openShareRequiredScreen(text: String)
  case selectedLanguage(language: LanguageModel)
  case error(ErrorType)
}
