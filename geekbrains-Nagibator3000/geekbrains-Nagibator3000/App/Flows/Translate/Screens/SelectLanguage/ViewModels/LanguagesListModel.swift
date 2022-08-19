//
//  LanguagesListModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 19.08.2022.
//

import RxDataSources

struct LanguagesListModel: Equatable {
  let items: [SelectLanguageCellModel]

  init(items: [SelectLanguageCellModel]) {
    self.items = items
  }

  static func == (lhs: LanguagesListModel, rhs: LanguagesListModel) -> Bool {
    lhs.items.count == rhs.items.count
  }
}

extension LanguagesListModel: SectionModelType {
  typealias Item = SelectLanguageCellModel

  init(original: Self, items: [Self.Item]) {
    self = original
  }
}

