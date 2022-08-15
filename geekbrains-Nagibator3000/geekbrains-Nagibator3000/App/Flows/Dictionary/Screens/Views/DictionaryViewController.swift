//
//  DictionaryViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import RxSwift

final class DictionaryViewController: UIViewController {
    var viewModel: DictionaryViewModel!
    
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
        bindLifeCycle()
        bindViewModel()
    }
    
    //MARK: - Config
    
    private func initialConfig() {
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerClass(DictionaryTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.setupTitle(text: Constants.title)
    }
    
    private func bindLifeCycle() {
      rx.viewWillAppear
        .bind(to: viewModel.input.enterScreen)
        .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.translations.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: DictionaryTableViewCell.reuseIdentifier,
                                         cellType: DictionaryTableViewCell.self)) {
                row, translation, cell in
                cell.config(with: translation)
            }.disposed(by: disposeBag)
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Dictionary".localized
    
    static let backgroundColor = ColorScheme.raspberryRose.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
