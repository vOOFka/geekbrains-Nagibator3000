//
//  SelectLanguageViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit
import RxCocoa
import RxSwift

final class SelectLanguageViewController: UITableViewController {
  //    var viewModel: SelectLanguageViewModel
  //    
  //    // MARK: - Init & Lifecycle
  //    
  //    init(viewModel: TranslateViewModel, type: LanguageType) {
  //        self.viewModel = SelectLanguageViewModel(translateViewModel: viewModel, type: type)
  //        super.init(nibName: nil, bundle: nil)
  //    }
  //    
  //    required init?(coder aDecoder: NSCoder) {
  //        fatalError("init(coder:) has not been implemented")
  //    }
  //
  //    override func viewDidLoad() {
  //        super.viewDidLoad()
  //        self.navigationItem.title = Constants.title
  //        
  //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.doneButtonTitle, style: .done, target: self, action: #selector(dismissVC))
  //        
  //        configTableView()
  //        updateUI()
  //    }
  //    
  //    private func configTableView() {
  //        tableView.registerClass(SelectLanguageCell.self)
  //        tableView.showsVerticalScrollIndicator = false
  //        tableView.separatorColor = .clear
  //        tableView.separatorStyle = .none
  //        tableView.allowsMultipleSelection = false
  //    }
  //    
  //    private func updateUI() {
  //        viewModel.update() { [weak self] in
  //            self?.tableView.reloadData()
  //        }
  //    }
  //    
  //    // MARK: - Table view delegate & datasourse
  //    
  //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //        viewModel.cellsArray.count
  //    }
  //    
  //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //        let cell = tableView.dequeueReusableCell(SelectLanguageCell.self, for: indexPath)
  //        cell.config(with: viewModel.cellsArray[indexPath.row])
  //        return cell
  //    }
  //    
  //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  //        let previousIndex = IndexPath(row: viewModel.selectIndex, section: indexPath.section)
  //
  //        viewModel.updateCell(with: indexPath.row)
  //        tableView.reloadRows(at: [indexPath, previousIndex], with: .none)
  //    }
  //    
  //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //        return 52.0
  //    }
  //    
  //    override func viewDidLayoutSubviews() {
  //        super.viewDidLayoutSubviews()
  //        layoutSubviews()
  //    }
  //    
  //    private func layoutSubviews() {
  //        tableView.pin.all()
  //    }
  //    
  //    // MARK: - Button actions
  //    @objc private func dismissVC() {
  //        self.dismiss(animated: true, completion: nil)
  //    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Select language".localized
    static let doneButtonTitle = "Done".localized
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
