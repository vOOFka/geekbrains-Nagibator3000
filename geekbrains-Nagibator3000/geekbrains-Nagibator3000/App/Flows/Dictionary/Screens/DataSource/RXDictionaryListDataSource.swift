//
//  RXDictionaryListDataSource.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 20.08.2022.
//

import RxDataSources
import UIKit

final class RXDictionaryListDataSource: RxTableViewSectionedAnimatedDataSource<DictionarySectionModel> {
    init() {
        super.init(
            animationConfiguration: AnimationConfiguration(insertAnimation: .middle,
                                                           reloadAnimation: .automatic,
                                                           deleteAnimation: .left),
            configureCell: { _, tableView, indexPath, translation in
                RXDictionaryListDataSource.getCell(item: translation, tableView: tableView, indexPath: indexPath)
            }
        )
    }
    
    private static func getCell(
        item: DictionarySectionModel.Item,
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DictionaryTableViewCell.self, for: indexPath)
        cell.config(item: DictionaryTableCellViewModel(with: item))
        return cell
    }
}
