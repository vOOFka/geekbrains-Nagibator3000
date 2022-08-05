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
    var viewModel: SelectLanguageViewModel {
        didSet {
            viewModel.update()
        }
    }
    
    // MARK: - Init & Lifecycle
    
    init(viewModel: TranslateViewModel) {
        self.viewModel = SelectLanguageViewModel(translateViewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SelectLanguageCell.self)
        tableView.showsVerticalScrollIndicator = false
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Select language".localized
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
