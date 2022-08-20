//
//  SelectLanguageCellModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import Foundation

class SelectLanguageCellModel {
  let language: LanguageModel
  let isSelected: Bool
  
  init(language: LanguageModel, selected: Bool) {
    self.language = language
    self.isSelected = selected
  }
}
