//
//  SelectLanguageViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit
import PinLayout
import RxCocoa
import RxSwift

final class SelectLanguageViewController: UITableViewController {
    var viewModel: SelectLanguageViewModel
    
    // MARK: - Init & Lifecycle
    
    init(viewModel: TranslateViewModel, type: LanguageType) {
        self.viewModel = SelectLanguageViewModel(translateViewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        updateUI()
    }
    
    private func configTableView() {
        tableView.registerClass(SelectLanguageCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func updateUI() {
        viewModel.update() { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view delegate & datasourse
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellsArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SelectLanguageCell.self, for: indexPath)
        guard let cellsViewModels = viewModel.cellsArray else {
            return cell
        }
        cell.config(with: cellsViewModels[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        tableView.pin.all()
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Select language".localized
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
