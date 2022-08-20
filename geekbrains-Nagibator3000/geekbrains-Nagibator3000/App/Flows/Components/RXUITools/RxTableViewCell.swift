//
//  RxTableViewCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 19.08.2022.
//

import RxSwift
import UIKit

class RxTableViewCell<CellModel>: UITableViewCell {
  internal var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  func config(item: CellModel) { }
}
