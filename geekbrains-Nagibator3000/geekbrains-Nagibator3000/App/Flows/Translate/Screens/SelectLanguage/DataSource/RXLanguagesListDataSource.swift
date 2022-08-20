//
//  RXLanguagesListDataSource.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 19.08.2022.
//

import RxDataSources
import UIKit

class RXLanguagesListDataSource: RxTableViewSectionedReloadDataSource<LanguagesListModel> {
  init() {
    super.init { _, tableView, indexPath, item in
      RXLanguagesListDataSource.getCell(item: item, tableView: tableView, indexPath: indexPath)
    }
  }

  private static func getCell(
    item: LanguagesListModel.Item,
    tableView: UITableView,
    indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(SelectLanguageCell.self, for: indexPath)

    cell.config(item: item)
    return cell
  }
}

