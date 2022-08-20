//
//  SelectLanguageViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit
import RxCocoa
import RxSwift

class SelectLanguageViewController: UITableViewController {
  private let disposeBag = DisposeBag()
  private var dataSource = RXLanguagesListDataSource()
  
  var viewModel: SelectLanguageViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configTableView()
    setupNavigation()
    setupBind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    layoutSubviews()
  }
  
  private func layoutSubviews() {
    tableView.pin.all()
  }
  
  private func configTableView() {
    tableView.registerClass(SelectLanguageCell.self)
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorColor = Constants.greenColor
    tableView.separatorStyle = .singleLine
    tableView.allowsMultipleSelection = false
    tableView.delegate = nil
    tableView.dataSource = nil
  }
  
  private func setupNavigation() {
    self.navigationItem.title = Constants.title
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Constants.doneButtonTitle,
      style: .done,
      target: self,
      action: #selector(dismissVC)
    )
  }
  
  private func setupBind() {
    rx.viewWillAppear
      .bind(to: viewModel.input.enterScreen)
      .disposed(by: disposeBag)
    
    viewModel.output.source
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .map { $0.item }
      .bind(to: viewModel.input.selectedCell)
      .disposed(by: disposeBag)
  }
  
  @objc private func dismissVC() {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: - Constants

private enum Constants {
  static let title = "Select language".localized
  static let doneButtonTitle = "Done".localized
  
  static let backgroundColor = ColorScheme.fuchsiaBlue.color
  static let whiteColor = ColorScheme.white.color
  static let greenColor = ColorScheme.greenPantone.color
}
